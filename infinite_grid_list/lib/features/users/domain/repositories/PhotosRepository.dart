import 'package:infinite_grid_list/features/users/domain/entities/photo.dart';

/// PhotosRepository
///
/// The repository for photos
abstract class PhotosRepository {
  Future<Photo> getPhotos({int start = 0, int limit = 20});
}
