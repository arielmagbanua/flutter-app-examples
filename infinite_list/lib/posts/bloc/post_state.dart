part of 'post_bloc.dart';

/// Different status of post fetching.
///
/// [initial] - will tell the presentation layer it needs to
/// render a loading indicator while the initial batch of posts are loaded.
///
/// [success] - will tell the presentation layer it has content to render.
///
/// [failure] - will tell the presentation layer that
/// an error has occurred while fetching posts.
enum PostStatus { initial, success, failure }

/// PostState
///
/// This the state class for bloc event.
class PostState extends Equatable {
  /// The status of post fetching.
  final PostStatus status;

  /// The list of fetched posts.
  final List<Post> posts;

  /// Indicates whether the app has reached the limit of available posts.
  final bool hasReachedMax;

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  /// Create a new instance of the state.
  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
