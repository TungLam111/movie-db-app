import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mock_bloc_stream/features/auth/domain/repositories/auth_repository.dart';
import 'package:mock_bloc_stream/features/movie/data/repositories/movie_repository_impl.dart';
import 'package:mock_bloc_stream/features/movie/domain/repositories/movie_repository.dart';
import 'package:mock_bloc_stream/features/tv/domain/repositories/tv_repository.dart';

class RepositoryDI {
  RepositoryDI._();

  static Future<void> init(GetIt locator) async {
    // repository
    locator.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authDatasource: locator()),
    );
    locator.registerLazySingleton<MovieRepository>(
      () => MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ),
    );
    locator.registerLazySingleton<TvRepository>(
      () => TvRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ),
    );
  }
}
