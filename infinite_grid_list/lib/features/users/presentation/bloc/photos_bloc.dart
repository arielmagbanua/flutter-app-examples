import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/photo.dart';
import '../../domain/use_cases/get_photos.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final GetPhotos getPhotos;

  PhotosBloc({required this.getPhotos}) : super(PhotosState());

  @override
  Stream<Transition<PhotosEvent, PhotosState>> transformEvents(
    Stream<PhotosEvent> events,
    TransitionFunction<PhotosEvent, PhotosState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PhotosState> mapEventToState(
    PhotosEvent event,
  ) async* {
    if (event is Refresh) {
      // refreshing the list so return an initial state again
      yield state.copyWith(
          status: PhotosStatus.initial,
          photos: <Photo>[],
          hasReachedMax: false
      );

      yield await _mapPhotosFetchedToState(state);
    } else {
      yield await _mapPhotosFetchedToState(state);
    }
  }

  Future<PhotosState> _mapPhotosFetchedToState(PhotosState state) async {
    if (state.hasReachedMax) {
      return state;
    }

    try {
      if (state.status == PhotosStatus.initial) {
        final List<Photo> photos = await getPhotos();
        return state.copyWith(
          status: PhotosStatus.success,
          photos: photos,
          hasReachedMax: false,
        );
      }

      final List<Photo> photos = await getPhotos(state.photos.length);

      if (photos.isEmpty) {
        // No more photos available therefore we reached the limit
        // now return a state that signifies that we reached the limit of posts.
        return state.copyWith(hasReachedMax: true);
      }

      return state.copyWith(
        status: PhotosStatus.success,
        photos: List.of(state.photos)..addAll(photos),
        hasReachedMax: false,
      );
    } on Exception {
      return state.copyWith(status: PhotosStatus.failure);
    }
  }
}
