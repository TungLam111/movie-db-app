import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/features/auth/domain/usecases/auth_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_detail_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_images_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_recommendations_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_watchlist_status_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_now_playing_movies_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_popular_movies_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_watchlist_movies_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/remove_watchlist_movie_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/save_watchlist_movie.dart';
import 'package:mock_bloc_stream/features/search/domain/usecases/search_movies_usecase.dart';
import 'package:mock_bloc_stream/features/search/domain/usecases/search_tvs_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_on_the_air_tvs_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_popular_tvs_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_top_rated_tvs_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_tv_detail_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_tv_images_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_tv_recommendations_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_tv_season_episodes_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_tv_watchlist_status_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_watchlist_tvs_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/remove_watchlist_tv_usecase.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/save_watchlist_tv_usecase.dart';

class UsecaseDI {
  UsecaseDI._();

  static Future<void> init(GetIt locator) async {
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
  }
}
