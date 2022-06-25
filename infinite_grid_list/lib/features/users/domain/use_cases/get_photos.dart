import '../repositories/photos_repository.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entities/photo.dart';

/// GetPhotos
///
/// The use case for retrieving photos
class GetPhotos extends UseCase<List<Photo>, int> {
  /// The photos repository instance
  final PhotosRepository photosRepository;

  GetPhotos(this.photosRepository);

  /// Retrieves photos
  ///
  /// This makes the class callable.
  ///
  /// [start] - The index / page of the photo records.
  /// [limit] - The maximum number of photos that is expected to be returned.
  @override
  Future<List<Photo>> call([int? start = 0, int? limit = 20]) {
    return photosRepository.getPhotos(
          start: start!,
          limit: limit!,
        );
  }
}
