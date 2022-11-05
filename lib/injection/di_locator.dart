import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/auth/data/datasources/auth_datasources.dart';
import 'package:mock_bloc_stream/auth/data/repositories/auth_repository_impl.dart';
import 'package:mock_bloc_stream/auth/domain/repositories/auth_repository.dart';
import 'package:mock_bloc_stream/auth/domain/usecases/auth_usecase.dart';
import 'package:mock_bloc_stream/auth/presentation/bloc/auth_bloc.dart';
import 'package:mock_bloc_stream/core/api/api_service.dart';
import 'package:mock_bloc_stream/core/app_bloc.dart';
import 'package:mock_bloc_stream/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/injection/shared_prefs_di.dart';
import 'package:mock_bloc_stream/movie/data/datasources/db/movie_database_helper.dart';
import 'package:mock_bloc_stream/movie/data/datasources/movie_local_data_source.dart';
import 'package:mock_bloc_stream/movie/data/datasources/movie_remote_data_source.dart';
import 'package:mock_bloc_stream/movie/data/repositories/movie_repository_impl.dart';
import 'package:mock_bloc_stream/movie/domain/repositories/movie_repository.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_detail_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_images_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_recommendations_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_watchlist_status_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_popular_movies_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_watchlist_movies_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/remove_watchlist_movie_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/save_watchlist_movie.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_images_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_list_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/search/domain/usecases/search_movies_usecase.dart';
import 'package:mock_bloc_stream/search/domain/usecases/search_tvs_usecase.dart';
import 'package:mock_bloc_stream/search/presentation/bloc/search_bloc.dart';
import 'package:mock_bloc_stream/tv/data/datasources/db/tv_database_helper.dart';
import 'package:mock_bloc_stream/tv/data/datasources/tv_local_data_source.dart';
import 'package:mock_bloc_stream/tv/data/datasources/tv_remote_data_source.dart';
import 'package:mock_bloc_stream/tv/domain/repositories/tv_repository.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_on_the_air_tvs_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_popular_tvs_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_top_rated_tvs_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_tv_detail_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_tv_images_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_tv_recommendations_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_tv_season_episodes_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_tv_watchlist_status_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_watchlist_tvs_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/remove_watchlist_tv_usecase.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/save_watchlist_tv_usecase.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_images_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_list_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/tv_season_episodes_bloc.dart';
import 'package:mock_bloc_stream/tv/presentation/bloc/watchlist_tv_bloc.dart';
import 'package:mock_bloc_stream/utils/custom_interceptor.dart';
import 'package:mock_bloc_stream/utils/urls.dart';

final GetIt locator = GetIt.instance;

Future<void> init() async {
  await SharedPrefDI.init(locator);

  locator.registerFactory(() => MovieSearchBloc(locator()));
  locator.registerFactory(() => TvSearchBloc(locator()));

  locator.registerFactory(
    () => AuthBloc(
      loginUsecase: locator(),
      logoutUsecase: locator(),
    ),
  );

  // custom bloc
  locator.registerFactory(() => HomeBloc());
  // provider

  locator.registerFactory(
    () => MovieListBloc(
      getNowPlayingMoviesUsecase: locator(),
      getPopularMoviesUsecase: locator(),
      getTopRatedMoviesUsecase: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesBloc(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieImagesBloc(
      getMovieImagesUsecase: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieBloc(
      getWatchlistMoviesUsecase: locator(),
    ),
  );

  locator.registerFactory(
    () => TvListBloc(
      getOnTheAirTvsUsecase: locator(),
      getPopularTvsUsecase: locator(),
      getTopRatedTvsUsecase: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTvsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTvsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailBloc(
      getTvDetailUsecase: locator(),
      getTvRecommendationsUsecase: locator(),
      getWatchListStatusUsecase: locator(),
      saveWatchlistUsecase: locator(),
      removeWatchlistUsecase: locator(),
    ),
  );
  locator.registerFactory(
    () => TvSeasonEpisodesBloc(
      getTvSeasonEpisodes: locator(),
    ),
  );
  locator.registerFactory(
    () => TvImagesBloc(
      getTvImagesUsecase: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvBloc(
      getWatchlistTvsUsecase: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMoviesUsecase(locator()));
  locator.registerLazySingleton(() => GetPopularMoviesUsecase(locator()));
  locator.registerLazySingleton(() => GetTopRatedMoviesUsecase(locator()));
  locator.registerLazySingleton(() => GetMovieDetailUsecase(locator()));
  locator
      .registerLazySingleton(() => GetMovieRecommendationsUsecase(locator()));
  locator.registerLazySingleton(() => SearchMoviesUsecase(locator()));
  locator.registerLazySingleton(() => GetMovieImagesUsecase(locator()));
  locator.registerLazySingleton(() => GetWatchlistMoviesUsecase(locator()));

  locator.registerLazySingleton(() => GetOnTheAirTvsUsecase(locator()));
  locator.registerLazySingleton(() => GetPopularTvsUsecase(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvsUsecase(locator()));
  locator.registerLazySingleton(() => GetTvDetailUsecase(locator()));
  locator.registerLazySingleton(() => GetTvSeasonEpisodesUsecase(locator()));
  locator.registerLazySingleton(() => GetTvRecommendationsUsecase(locator()));
  locator.registerLazySingleton(() => SearchTvsUsecase(locator()));
  locator.registerLazySingleton(() => GetTvImagesUsecase(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvsUsecase(locator()));
  locator.registerLazySingleton(() => LoginUsecase(locator()));
  locator.registerLazySingleton(() => LogoutUsecase(locator()));

  locator.registerLazySingleton(
    () => GetMovieWatchlistStatusUsecase(
      movieRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => GetTvWatchlistStatusUsecase(
      tvRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveWatchlistMovieUsecase(
      movieRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SaveWatchlistTvUsecase(
      tvRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveWatchlistMovieUsecase(
      movieRepository: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => RemoveWatchlistTvUsecase(
      tvRepository: locator(),
    ),
  );

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

  // data sources
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

  // helper
  locator.registerLazySingleton<MovieDatabaseHelper>(
    () => MovieDatabaseHelper(),
  );
  locator.registerLazySingleton<TvDatabaseHelper>(
    () => TvDatabaseHelper(),
  );
  locator.registerLazySingleton<UserService>(() => UserServiceImpl());
  locator.registerLazySingleton<LanguageService>(() => LanguageServiceImpl());
  locator.registerFactory<AppBloc>(
    () => AppBloc(
      userService: locator(),
      languageService: locator(),
    ),
  );

  locator.registerLazySingleton<CustomInterceptors>(() => CustomInterceptors());

  // external
  locator.registerFactory<Dio>(() {
    final Dio dio = Dio(
      BaseOptions(),
    )..interceptors.add(
        locator<CustomInterceptors>(),
      );
    return dio;
  });

  locator.registerLazySingleton<ApiService>(
    () => ApiService(
      locator(),
      baseUrl: Urls.baseUrl,
    ),
  );
}
