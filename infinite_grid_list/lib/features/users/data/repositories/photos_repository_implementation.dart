import 'package:infinite_grid_list/features/users/data/models/photo_model.dart';

import '../../domain/repositories/photos_repository.dart';
import '../sources/photos_remote_data_source.dart';

/// PhotosRepositoryImplementation
///
/// The implementation or concretion class for PhotosRepository
class PhotosRepositoryImplementation extends PhotosRepository {
  final PhotosRemoteDataSource photosRemoteDataSource;

  PhotosRepositoryImplementation({required this.photosRemoteDataSource});

  /// Retrieves list of photos.
  @override
  Future<List<PhotoModel>> getPhotos({int start = 0, int limit = 20}) {
    return photosRemoteDataSource.getPhotos(start: start, limit: limit);
  }
}
