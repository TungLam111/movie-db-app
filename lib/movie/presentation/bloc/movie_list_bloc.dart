import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_now_playing_movies_usecase.dart';
import '../../domain/usecases/get_popular_movies_usecase.dart';
import '../../domain/usecases/get_top_rated_movies_usecase.dart';

class MovieListBloc extends BaseBloc {
  MovieListBloc({
    required this.getNowPlayingMoviesUsecase,
    required this.getPopularMoviesUsecase,
    required this.getTopRatedMoviesUsecase,
  });

  final BehaviorSubject<List<Movie>> _nowPlayingMovies =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get nowPlayingMoviesStream =>
      _nowPlayingMovies.stream.asBroadcastStream();
  List<Movie> get nowPlayingMovies => _nowPlayingMovies.value;

  final BehaviorSubject<RequestState> _nowPlayingState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get nowPlayingStateStream =>
      _nowPlayingState.stream.asBroadcastStream();

  final BehaviorSubject<List<Movie>> _popularMovies =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get popularMoviesStream =>
      _popularMovies.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _popularMoviesState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get popularMoviesStateStream =>
      _popularMoviesState.stream.asBroadcastStream();

  final BehaviorSubject<List<Movie>> _topRatedMovies =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get topRatedMoviesStream =>
      _topRatedMovies.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _topRatedMoviesState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get topRatedMoviesStateStream =>
      _topRatedMoviesState.stream.asBroadcastStream();

  final GetNowPlayingMoviesUsecase getNowPlayingMoviesUsecase;
  final GetPopularMoviesUsecase getPopularMoviesUsecase;
  final GetTopRatedMoviesUsecase getTopRatedMoviesUsecase;

  Future<void> fetchNowPlayingMovies() async {
    _nowPlayingState.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getNowPlayingMoviesUsecase.execute();
    result.fold(
      (Failure failure) {
        _nowPlayingState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _nowPlayingState.add(RequestState.loaded);
        _nowPlayingMovies.add(moviesData);
      },
    );
  }

  Future<void> fetchPopularMovies() async {
    _popularMoviesState.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getPopularMoviesUsecase.execute();
    result.fold(
      (Failure failure) {
        _popularMoviesState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _popularMoviesState.add(RequestState.loaded);
        _popularMovies.add(moviesData);
      },
    );
  }

  Future<void> fetchTopRatedMovies() async {
    _topRatedMoviesState.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getTopRatedMoviesUsecase.execute();
    result.fold(
      (Failure failure) {
        _topRatedMoviesState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _topRatedMoviesState.add(RequestState.loaded);
        _topRatedMovies.add(moviesData);
      },
    );
  }

  @override
  void dispose() {
    _nowPlayingMovies.close();
    _nowPlayingState.close();
    _popularMovies.close();
    _popularMoviesState.close();
    _topRatedMovies.close();
    _topRatedMoviesState.close();
    super.dispose();
  }
}
