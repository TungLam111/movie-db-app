import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/api/api_service.dart';
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

class OpenbookProvider extends StatefulWidget {
  const OpenbookProvider({
    Key? key,
    required this.child,
    required this.apiService,
    required this.tvDatabaseHelper,
    required this.movieDatabaseHelper,
  }) : super(key: key);
  final Widget child;
  final ApiService apiService;
  final TvDatabaseHelper tvDatabaseHelper;
  final MovieDatabaseHelper movieDatabaseHelper;

  static OpenbookProviderState of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_OpenbookProvider>())!
        .data;
  }

  @override
  State<OpenbookProvider> createState() => OpenbookProviderState();
}

class OpenbookProviderState extends State<OpenbookProvider> {
  late final ApiService _apiService = widget.apiService;
  late TvDatabaseHelper tvDatabaseHelper = widget.tvDatabaseHelper;
  late MovieDatabaseHelper movieDatabaseHelper = widget.movieDatabaseHelper;

  late TvLocalDataSource tvLocalDataSource;
  late TvRemoteDataSource tvRemoteDataSource;
  late MovieLocalDataSource movieLocalDataSource;
  late MovieRemoteDataSource movieRemoteDataSource;

  late TvRepository tvRepository;
  late MovieRepository movieRepository;

  late RemoveWatchlistTvUsecase removeWatchlistTvUseCase;
  late RemoveWatchlistMovieUsecase removeWatchlistMovieUseCase;
  late SaveWatchlistTvUsecase saveWatchlistTvUsecase;
  late SaveWatchlistMovieUsecase saveWatchlistMovieUseCase;
  late GetTvWatchlistStatusUsecase getTvWatchlistStatus;
  late GetMovieWatchlistStatusUsecase getMovieWatchlistStatusUseCase;
  late GetWatchlistTvsUsecase getWatchlistTvsUsecase;
  late GetTvImagesUsecase getTvImages;
  late SearchTvsUsecase searchTvsUseCase;
  late GetTvRecommendationsUsecase getTvRecommendationsUsecase;
  late GetTvSeasonEpisodesUsecase getTvSeasonEpisodesUsecase;
  late GetTvDetailUsecase getTvDetailUsecase;
  late GetTopRatedTvsUsecase getTopRatedTvsUsecase;
  late GetPopularTvsUsecase getPopularTvsUsecase;
  late GetOnTheAirTvsUsecase getOnTheAirTvsUsecase;
  late GetWatchlistMoviesUsecase getWatchlistMoviesUseCase;
  late GetMovieImagesUsecase getMovieImagesUseCase;
  late SearchMoviesUsecase searchMoviesUseCase;
  late GetMovieRecommendationsUsecase getMovieRecommendationsUseCase;
  late GetMovieDetailUsecase getMovieDetailUseCase;
  late GetTopRatedMoviesUsecase getTopRatedMoviesUseCase;
  late GetPopularMoviesUsecase getPopularMoviesUseCase;
  late GetNowPlayingMoviesUsecase getNowPlayingMoviesUseCase;

  late WatchlistTvBloc watchlistTvBloc;
  late TvImagesBloc tvImagesBloc;
  late TvSeasonEpisodesBloc tvSeasonEpisodesBloc;
  late TvDetailBloc tvDetailBloc;
  late TopRatedTvsBloc topRatedTvsBloc;
  late PopularTvsBloc popularTvsBloc;
  late TvListBloc tvListBloc;
  late MovieImagesBloc movieImagesBloc;
  late MovieDetailBloc movieDetailBloc;
  late TopRatedMoviesBloc topRatedMoviesBloc;
  late PopularMoviesBloc popularMoviesBloc;
  late MovieListBloc movieListBloc;
  late TvSearchBloc tvSearchBloc;
  late MovieSearchBloc movieSearchBloc;

  @override
  void initState() {
    super.initState();
    tvLocalDataSource = TvLocalDataSourceImpl(databaseHelper: tvDatabaseHelper);
    tvRemoteDataSource = TvRemoteDataSourceImpl(client: _apiService);
    movieLocalDataSource =
        MovieLocalDataSourceImpl(databaseHelper: movieDatabaseHelper);
    movieRemoteDataSource = MovieRemoteDataSourceImpl(client: _apiService);
    tvRepository = TvRepositoryImpl(
      remoteDataSource: tvRemoteDataSource,
      localDataSource: tvLocalDataSource,
    );
    movieRepository = MovieRepositoryImpl(
      localDataSource: movieLocalDataSource,
      remoteDataSource: movieRemoteDataSource,
    );

    removeWatchlistTvUseCase =
        RemoveWatchlistTvUsecase(tvRepository: tvRepository);
    removeWatchlistMovieUseCase =
        RemoveWatchlistMovieUsecase(movieRepository: movieRepository);
    saveWatchlistTvUsecase = SaveWatchlistTvUsecase(tvRepository: tvRepository);
    saveWatchlistMovieUseCase =
        SaveWatchlistMovieUsecase(movieRepository: movieRepository);
    getTvWatchlistStatus =
        GetTvWatchlistStatusUsecase(tvRepository: tvRepository);
    getMovieWatchlistStatusUseCase =
        GetMovieWatchlistStatusUsecase(movieRepository: movieRepository);
    getWatchlistTvsUsecase = GetWatchlistTvsUsecase(tvRepository);
    getTvImages = GetTvImagesUsecase(tvRepository);
    searchTvsUseCase = SearchTvsUsecase(tvRepository);
    getTvRecommendationsUsecase = GetTvRecommendationsUsecase(tvRepository);
    getTvSeasonEpisodesUsecase = GetTvSeasonEpisodesUsecase(tvRepository);
    getTvDetailUsecase = GetTvDetailUsecase(tvRepository);
    getTopRatedTvsUsecase = GetTopRatedTvsUsecase(tvRepository);
    getPopularTvsUsecase = GetPopularTvsUsecase(tvRepository);
    getOnTheAirTvsUsecase = GetOnTheAirTvsUsecase(tvRepository);
    getWatchlistMoviesUseCase = GetWatchlistMoviesUsecase(movieRepository);
    getMovieImagesUseCase = GetMovieImagesUsecase(movieRepository);
    searchMoviesUseCase = SearchMoviesUsecase(movieRepository);
    getMovieRecommendationsUseCase =
        GetMovieRecommendationsUsecase(movieRepository);
    getMovieDetailUseCase = GetMovieDetailUsecase(movieRepository);
    getTopRatedMoviesUseCase = GetTopRatedMoviesUsecase(movieRepository);
    getPopularMoviesUseCase = GetPopularMoviesUsecase(movieRepository);
    getNowPlayingMoviesUseCase = GetNowPlayingMoviesUsecase(movieRepository);

    watchlistTvBloc =
        WatchlistTvBloc(getWatchlistTvsUsecase: getWatchlistTvsUsecase);
    tvImagesBloc = TvImagesBloc(getTvImagesUsecase: getTvImages);
    tvSeasonEpisodesBloc =
        TvSeasonEpisodesBloc(getTvSeasonEpisodes: getTvSeasonEpisodesUsecase);
    tvDetailBloc = TvDetailBloc(
      getTvDetailUsecase: getTvDetailUsecase,
      getTvRecommendationsUsecase: getTvRecommendationsUsecase,
      getWatchListStatusUsecase: getTvWatchlistStatus,
      saveWatchlistUsecase: saveWatchlistTvUsecase,
      removeWatchlistUsecase: removeWatchlistTvUseCase,
    );

    topRatedTvsBloc = TopRatedTvsBloc(getTopRatedTvsUsecase);
    popularTvsBloc = PopularTvsBloc(getPopularTvsUsecase);
    tvListBloc = TvListBloc(
      getOnTheAirTvsUsecase: getOnTheAirTvsUsecase,
      getPopularTvsUsecase: getPopularTvsUsecase,
      getTopRatedTvsUsecase: getTopRatedTvsUsecase,
    );

    movieImagesBloc =
        MovieImagesBloc(getMovieImagesUsecase: getMovieImagesUseCase);
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: getMovieDetailUseCase,
      getMovieRecommendations: getMovieRecommendationsUseCase,
      getWatchListStatus: getMovieWatchlistStatusUseCase,
      saveWatchlist: saveWatchlistMovieUseCase,
      removeWatchlist: removeWatchlistMovieUseCase,
    );
    topRatedMoviesBloc =
        TopRatedMoviesBloc(getTopRatedMovies: getTopRatedMoviesUseCase);
    popularMoviesBloc = PopularMoviesBloc(getPopularMoviesUseCase);
    movieListBloc = MovieListBloc(
      getNowPlayingMoviesUsecase: getNowPlayingMoviesUseCase,
      getPopularMoviesUsecase: getPopularMoviesUseCase,
      getTopRatedMoviesUsecase: getTopRatedMoviesUseCase,
    );

    tvSearchBloc = TvSearchBloc(searchTvsUseCase);
    movieSearchBloc = MovieSearchBloc(searchMoviesUseCase);
  }

  @override
  Widget build(BuildContext context) {
    return _OpenbookProvider(data: this, child: widget.child);
  }
}

class _OpenbookProvider extends InheritedWidget {
  const _OpenbookProvider({Key? key, required this.data, required Widget child})
      : super(key: key, child: child);
  final OpenbookProviderState data;

  @override
  bool updateShouldNotify(_OpenbookProvider old) {
    return true;
  }
}
