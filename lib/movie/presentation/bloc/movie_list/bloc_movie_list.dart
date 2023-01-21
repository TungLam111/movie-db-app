import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_list/action_movie_list.dart';
import 'package:mock_bloc_stream/movie/presentation/bloc/movie_list/state_movie_list.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies_usecase.dart';
import '../../../domain/usecases/get_popular_movies_usecase.dart';
import '../../../domain/usecases/get_top_rated_movies_usecase.dart';

class BlocMovieList extends BaseBloc {
  BlocMovieList({
    required this.getNowPlayingMoviesUsecase,
    required this.getPopularMoviesUsecase,
    required this.getTopRatedMoviesUsecase,
  });

  final GetNowPlayingMoviesUsecase getNowPlayingMoviesUsecase;
  final GetPopularMoviesUsecase getPopularMoviesUsecase;
  final GetTopRatedMoviesUsecase getTopRatedMoviesUsecase;

  final StreamController<MovieListAction> actionController =
      StreamController<MovieListAction>();

  MovieListState get initialState => _state.value;
  Stream<MovieListState> get state =>
      _state.stream.distinct().asBroadcastStream();
  final BehaviorSubject<MovieListState> _state =
      BehaviorSubject<MovieListState>.seeded(
    MovieListState(),
  );

  void initActionListen() {
    actionController.stream.listen((MovieListAction event) {
      if (event is GetNowPlayingMovies) {
        onFetchNowPlayingMovies(event);
      } else if (event is GetPopularMovies) {
        onFetchPopularMovies(event);
      } else if (event is GetTopRatedMovies) {
        onFetchTopRatedMovies(event);
      }
    });
  }

  Future<void> onFetchNowPlayingMovies(MovieListAction event) async {
    _state.add(
      _state.value.rebuild(
        (MovieListStateBuilder p0) =>
            p0.nowPlayingMoviesState = RequestState.loading,
      ),
    );

    final Either<Failure, List<Movie>> result =
        await getNowPlayingMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _state.add(
          _state.value.rebuild(
            (MovieListStateBuilder p0) =>
                p0..nowPlayingMoviesState = RequestState.error,
          ),
        );
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _state.add(
          _state.value.rebuild(
            (MovieListStateBuilder p0) => p0
              ..nowPlayingMoviesState = RequestState.loaded
              ..nowPlayingMovies = moviesData,
          ),
        );
      },
    );
  }

  Future<void> onFetchPopularMovies(MovieListAction event) async {
    _state.add(
      _state.value.rebuild(
        (MovieListStateBuilder p0) =>
            p0.popularMoviesState = RequestState.loading,
      ),
    );

    final Either<Failure, List<Movie>> result =
        await getPopularMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _state.add(
          _state.value.rebuild(
            (MovieListStateBuilder p0) =>
                p0..popularMoviesState = RequestState.error,
          ),
        );
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _state.add(
          _state.value.rebuild(
            (MovieListStateBuilder p0) => p0
              ..popularMoviesState = RequestState.loaded
              ..popularMovies = moviesData,
          ),
        );
      },
    );
  }

  Future<void> onFetchTopRatedMovies(MovieListAction event) async {
    _state.add(
      _state.value.rebuild(
        (MovieListStateBuilder p0) =>
            p0.topRatedMoviesState = RequestState.loading,
      ),
    );

    final Either<Failure, List<Movie>> result =
        await getTopRatedMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _state.add(
          _state.value.rebuild(
            (MovieListStateBuilder p0) =>
                p0..topRatedMoviesState = RequestState.error,
          ),
        );
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _state.add(
          _state.value.rebuild(
            (MovieListStateBuilder p0) => p0
              ..topRatedMoviesState = RequestState.loaded
              ..topRatedMovies = moviesData,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _state.close();
    actionController.close();
    super.dispose();
  }
}
