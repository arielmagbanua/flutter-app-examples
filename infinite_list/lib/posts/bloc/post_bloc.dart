import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';

part 'post_event.dart';

part 'post_state.dart';

/// PostBloc
///
/// It will only be responding to a single event;
/// PostFetched which will be added by the presentation layer
/// whenever it needs more Posts to present.
///
/// For simplicity, our PostBloc will have a direct dependency
/// on an http client; however, in a production application we suggest
/// instead you inject an api client and use the repository pattern
class PostBloc extends Bloc<PostEvent, PostState> {
  static const POST_LIMIT = 20;

  final http.Client httpClient;

  PostBloc({required this.httpClient}) : super(PostState()) {
    on<PostFetched>(
      (PostFetched event, emit) async {
        // already reached the max so immediately do nothing and return the state.
        if (state.hasReachedMax) {
          return emit(state);
        }

        try {
          if (state.status == PostStatus.initial) {
            // Initial state fetch the first 20 posts and return a success state
            final posts = await _fetchPosts();
            emit(state.copyWith(
              status: PostStatus.success,
              posts: posts,
              hasReachedMax: false,
            ));
          }

          // Not initial state this means that we are fetching the next 20 posts.
          // This fetches from the end of the previous fetched posts and then
          // fetch new 20 posts.
          final posts = await _fetchPosts(state.posts.length);

          if (posts.isEmpty) {
            // No more posts available therefore we reached the limit
            // now return a state that signifies that we reached the limit of posts.
            return emit(state.copyWith(hasReachedMax: true));
          }

          // everything's fine now return a success state appending the fetched
          // posts to the existing list.
          return emit(state.copyWith(
            status: PostStatus.success,
            posts: List.of(state.posts)..addAll(posts),
            hasReachedMax: false,
          ));
        } on Exception {
          return emit(state.copyWith(status: PostStatus.failure));
        }
      },
      transformer: debounce(const Duration(milliseconds: 300)),
    );

    on<ListRefresh>(
      (ListRefresh event, emit) {
        emit(state.copyWith(
            status: PostStatus.initial, posts: <Post>[], hasReachedMax: false));
      },
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  EventTransformer<PostEvent> debounce<PostEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  /// _fetchPosts
  ///
  /// Fetches post starting at [startIndex] by default.
  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$POST_LIMIT'},
      ),
    );

    if (response.statusCode == 200) {
      // fetching successful then process the posts.
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return Post(
          id: json['id'] as int,
          title: json['title'] as String,
          body: json['body'] as String,
        );
      }).toList();
    }

    // something went wrong therefore throw an exception.
    throw Exception('Error fetching posts.');
  }
}
