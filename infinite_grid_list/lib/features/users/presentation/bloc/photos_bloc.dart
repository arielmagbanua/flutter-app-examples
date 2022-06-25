import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/photo.dart';
import '../../domain/use_cases/get_photos.dart';

part 'photos_event.dart';

part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final GetPhotos getPhotos;

  PhotosBloc({required this.getPhotos}) : super(PhotosState()) {
    on<PhotosFetched>(
      (PhotosFetched event, emit) async {
        if (state.hasReachedMax) {
          return emit(state);
        }

        try {
          if (state.status == PhotosStatus.initial) {
            final List<Photo> photos = await getPhotos();
            return emit(state.copyWith(
              status: PhotosStatus.success,
              photos: photos,
              hasReachedMax: false,
            ));
          }

          final List<Photo> photos = await getPhotos(state.photos.length);

          if (photos.isEmpty) {
            // No more photos available therefore we reached the limit
            // now return a state that signifies that we reached the limit of posts.
            return emit(state.copyWith(hasReachedMax: true));
          }

          return emit(state.copyWith(
            status: PhotosStatus.success,
            photos: List.of(state.photos)..addAll(photos),
            hasReachedMax: false,
          ));
        } on Exception {
          return emit(state.copyWith(status: PhotosStatus.failure));
        }
      },
      transformer: debounce(const Duration(milliseconds: 300)),
    );

    on<Refresh>(
      (Refresh event, emit) {
        return emit(state.copyWith(
            status: PhotosStatus.initial,
            photos: <Photo>[],
            hasReachedMax: false));
      },
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  EventTransformer<PhotosEvent> debounce<PhotosEvent>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
