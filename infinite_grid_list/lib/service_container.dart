import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'features/users/data/repositories/photos_repository_implementation.dart';
import 'features/users/data/sources/photos_remote_data_source.dart';
import 'features/users/domain/repositories/photos_repository.dart';
import 'features/users/domain/use_cases/get_photos.dart';
import 'features/users/presentation/bloc/photos_bloc.dart';

class ServiceContainer {
  final GetIt sl;

  ServiceContainer(GetIt? sl) : this.sl = sl ?? GetIt.instance;

  Future<void> call() async {
    // blocs
    sl.registerFactory(() => PhotosBloc(getPhotos: sl()));

    // use cases
    sl.registerLazySingleton(() => GetPhotos(sl()));

    // repositories
    sl.registerLazySingleton<PhotosRepository>(
      () => PhotosRepositoryImplementation(photosRemoteDataSource: sl()),
    );

    // data sources
    sl.registerLazySingleton<PhotosRemoteDataSource>(
      () => PhotosRemoteDataSourceImplementation(client: sl()),
    );

    // external packages
    sl.registerLazySingleton(() => http.Client());
  }
}
