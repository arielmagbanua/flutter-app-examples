part of 'photos_bloc.dart';

/// Different status of photos fetching.
///
/// [initial] - will tell the presentation layer it needs to
/// render a loading indicator while the initial batch of posts are loaded.
///
/// [success] - will tell the presentation layer it has content to render.
///
/// [failure] - will tell the presentation layer that
/// an error has occurred while fetching photos.
enum PhotosStatus { initial, success, failure }

class PhotosState extends Equatable {
  /// The status of photos fetching.
  final PhotosStatus status;

  /// The list of fetched posts.
  final List<Photo> photos;

  /// Indicates whether the app has reached the limit of available posts.
  final bool hasReachedMax;

  const PhotosState({
    this.status = PhotosStatus.initial,
    this.photos = const <Photo>[],
    this.hasReachedMax = false,
  });

  /// Create a new instance of the state.
  PhotosState copyWith({
    PhotosStatus? status,
    List<Photo>? photos,
    bool? hasReachedMax,
  }) {
    return PhotosState(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${photos.length} }''';
  }

  @override
  List<Object?> get props => [status, photos, hasReachedMax];
}
