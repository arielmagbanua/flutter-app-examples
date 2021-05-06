import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/photo_model.dart';

abstract class PhotosRemoteDataSource {
  /// The base url of the API
  static const API_BASE_URL = 'jsonplaceholder.typicode.com';

  /// The photos API resource
  static const API_PHOTOS = 'photos';

  Future<List<PhotoModel>> getPhotos({int start = 0, int limit = 20});
}

class PhotosRemoteDataSourceImplementation extends PhotosRemoteDataSource {
  /// The http client instance
  final http.Client client;

  PhotosRemoteDataSourceImplementation({required this.client});

  /// Retrieves list of photos remotely.
  ///
  /// [start] - The starting index of the list of photos.
  /// [limit] - The limit of photos per api call.
  Future<List<PhotoModel>> getPhotos({int start = 0, int limit = 20}) async {
    final endpointUrl = Uri.http(
      PhotosRemoteDataSource.API_BASE_URL,
      PhotosRemoteDataSource.API_PHOTOS,
      <String, int>{'_start': start, '_limit': limit},
    );

    final response = await client.get(endpointUrl);
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;

      return body.map((dynamic json) {
        return PhotoModel(
          id: json['id'] as int,
          albumId: json['albumId'] as int,
          title: ['title'] as String,
          url: ['url'] as String,
          thumbnailUrl: ['thumbnailUrl'] as String,
        );
      }).toList();
    }

    throw Exception('Error fetching photos.');
  }
}
