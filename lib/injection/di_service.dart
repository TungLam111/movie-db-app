import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/core/api/api_service.dart';
import 'package:mock_bloc_stream/core/config/dio/custom_interceptor.dart';
import 'package:mock_bloc_stream/core/config/env/network_config.dart';
import 'package:mock_bloc_stream/core/service/language/language_service.dart';
import 'package:mock_bloc_stream/core/service/user/user_service.dart';
import 'package:mock_bloc_stream/features/movie/data/datasources/db/movie_database_helper.dart';
import 'package:mock_bloc_stream/features/tv/data/datasources/db/tv_database_helper.dart';

class ServiceDI {
  ServiceDI._();

  static Future<void> init(GetIt locator, BuildMode buildMode) async {
    locator.registerLazySingleton<MovieDatabaseHelper>(
      () => MovieDatabaseHelper(),
    );
    locator.registerLazySingleton<TvDatabaseHelper>(
      () => TvDatabaseHelper(),
    );
    locator.registerLazySingleton<UserService>(() => UserServiceImpl());
    locator.registerLazySingleton<LanguageService>(() => LanguageServiceImpl());
    locator
        .registerLazySingleton<NetWorkMode>(() => NetWorkMode(mode: buildMode));
    locator
        .registerLazySingleton<CustomInterceptors>(() => CustomInterceptors());
    locator.registerLazySingleton<CheckTokenAuthenticationInterceptor>(
      () => CheckTokenAuthenticationInterceptor(),
    );

    // external
    locator.registerFactory<Dio>(() {
      final Dio dio = Dio(
        BaseOptions(
          baseUrl: locator<NetWorkMode>().baseUrl,
          connectTimeout: locator<NetWorkMode>().connectTimeout,
          receiveTimeout: locator<NetWorkMode>().receiveTimeout,
          headers: locator<NetWorkMode>().headers,
        ),
      )..interceptors.addAll(<Interceptor>[
          locator<CustomInterceptors>(),
          locator<CheckTokenAuthenticationInterceptor>(),
        ]);
      return dio;
    });

    locator.registerLazySingleton<ApiService>(
      () => ApiService(
        locator<Dio>(),
      ),
    );
  }
}
