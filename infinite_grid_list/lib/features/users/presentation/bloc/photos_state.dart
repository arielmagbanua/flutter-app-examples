part of 'photos_bloc.dart';

abstract class PhotosState extends Equatable {
  const PhotosState();
}

/// Initial state
class PhotosInitial extends PhotosState {
  /// The list of fetched posts.
  final List<Photo> photos;

  /// Indicates whether the app has reached the limit of available posts.
  final bool hasReachedMax;

  const PhotosInitial({
    this.photos = const <Photo>[],
    this.hasReachedMax = false,
  });

  @override
  List<Object> get props => [];
}

/// Successful state
class PhotosSuccess extends PhotosState {
  /// The list of fetched posts.
  final List<Photo> photos;

  /// Indicates whether the app has reached the limit of available posts.
  final bool hasReachedMax;

  const PhotosSuccess({
    this.photos = const <Photo>[],
    this.hasReachedMax = false,
  });

  PhotosSuccess copyWith({
    List<Photo>? photos,
    bool? hasReachedMax,
  }) {
    return PhotosSuccess(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax != null ? hasReachedMax : false,
    );
  }

  @override
  List<Object> get props => [photos, hasReachedMax];
}

/// Failure state
class PhotosFailure extends PhotosState {
  @override
  List<Object> get props => [];
}
