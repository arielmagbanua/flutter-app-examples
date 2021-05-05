import 'package:equatable/equatable.dart';

/// Photo
///
/// The entity of photo
class Photo extends Equatable {
  final int id;
  final int albumId;
  final String title;
  final String url;
  final String thumbnailUrl;

  Photo({
    required this.id,
    required this.albumId,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  @override
  List<Object?> get props => [id, albumId, title, url, thumbnailUrl];
}
