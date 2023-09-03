import 'package:get_it/get_it.dart';
import 'package:mock_bloc_stream/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mock_bloc_stream/features/home/bloc/home_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:mock_bloc_stream/features/movie/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:mock_bloc_stream/features/search/presentation/bloc/search_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/popular_tvs_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/top_rated_tvs_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_list_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/tv_season_episodes_bloc.dart';
import 'package:mock_bloc_stream/features/tv/presentation/bloc/watchlist_tv_bloc.dart';

class BlocDI {
  BlocDI._();

  static Future<void> init(GetIt locator) async {
    locator.registerFactory(() => MovieSearchBloc(locator()));
    locator.registerFactory(() => TvSearchBloc(locator()));

    locator.registerFactory(
      () => AuthBloc(
        loginUsecase: locator(),
        logoutUsecase: locator(),
      ),
    );

    locator.registerFactory(() => HomeBloc());

    locator.registerFactory(
      () => MovieListBloc(
        getNowPlayingMoviesUsecase: locator(),
        getPopularMoviesUsecase: locator(),
        getTopRatedMoviesUsecase: locator(),
        getMovieImagesUsecase: locator(),
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
    locator.registerFactoryParam<MovieDetailBloc, int, void>(
      (int id, _) => MovieDetailBloc(
        movieId: id,
        getMovieDetail: locator(),
        getMovieRecommendations: locator(),
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator(),
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
        getTvImagesUsecase: locator(),
      ),
    );
    locator.registerFactory(
      () => PopularTvsBloc(
        getPopularTvsUsecase: locator(),
      ),
    );
    locator.registerFactory(
      () => TopRatedTvsBloc(
        getTopRatedTvsUsecase: locator(),
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
      () => WatchlistTvBloc(
        getWatchlistTvsUsecase: locator(),
      ),
    );
  }
}
