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

  PhotosBloc({required this.getPhotos}) : super(PhotosInitial());

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
      yield PhotosInitial();
    } else {
      yield await _mapState(state);
    }
  }

  Future<PhotosState> _mapState(PhotosState state) async {
    if (state is PhotosSuccess && state.hasReachedMax) {
      return state;
    }

    if (state is PhotosInitial) {
      final List<Photo> photos = await getPhotos(0);
      return PhotosSuccess(photos: photos, hasReachedMax: false);
    }

    state = state as PhotosSuccess;

    final List<Photo> photos = await getPhotos(state.photos.length);

    if (photos.isEmpty) {
      return state.copyWith(hasReachedMax: true);
    }

    return state.copyWith(
        photos: List.of(state.photos)..addAll(photos), hasReachedMax: false);
  }
}
