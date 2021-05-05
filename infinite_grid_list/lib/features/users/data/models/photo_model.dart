import 'package:infinite_grid_list/features/users/domain/entities/photo.dart';

/// PhotoModel
///
/// The model class for Photo
class PhotoModel extends Photo {
  PhotoModel({
    required int id,
    required int albumId,
    required String title,
    required String url,
    required String thumbnailUrl,
  }) : super(
    id: id,
    albumId: albumId,
    title: title,
    url: url,
    thumbnailUrl: thumbnailUrl
  );
}
