import '../entities/photo.dart';

/// PhotosRepository
///
/// The repository for photos
abstract class PhotosRepository {
  Future<List<Photo>> getPhotos({int start = 0, int limit = 20});
}
