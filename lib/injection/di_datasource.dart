import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/features/auth/data/datasources/auth_datasources.dart';
import 'package:mock_bloc_stream/features/movie/data/datasources/movie_local_data_source.dart';
import 'package:mock_bloc_stream/features/movie/data/datasources/movie_remote_data_source.dart';
import 'package:mock_bloc_stream/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:mock_bloc_stream/features/tv/data/datasources/tv_remote_data_source.dart';

class DatasourceDI {
  DatasourceDI._();

  static Future<void> init(GetIt locator) async {

    locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()),
    );
    locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()),
    );

    locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()),
    );
    locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()),
    );
    locator.registerLazySingleton<AuthDatasource>(
      () => AuthDataSourceImpl(client: locator()),
    );
  }
}
