import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies_usecase.dart';
import '../../../domain/usecases/get_popular_movies_usecase.dart';
import '../../../domain/usecases/get_top_rated_movies_usecase.dart';

class MovieListBloc extends BaseBloc {
  MovieListBloc._({
    required this.getNowPlayingMoviesUsecase,
    required this.getPopularMoviesUsecase,
    required this.getTopRatedMoviesUsecase,
    required this.addNowPlayingMovies,
    required this.addPopularMovies,
    required this.addTopRatedMovies,
    required this.nowPlayingMoviesStream,
    required this.popularMoviesStream,
    required this.topRatedMoviesStream,
    required this.nowPlayingMovies,
    required this.addNowPlayingState,
    required this.addPopularMoviesState,
    required this.addTopRatedMoviesState,
    required this.nowPlayingStateStream,
    required this.popularMoviesStateStream,
    required this.topRatedMoviesStateStream,
    required this.whatToDispose,
  });

  factory MovieListBloc({
    required GetNowPlayingMoviesUsecase getNowPlayingMoviesUsecase,
    required GetPopularMoviesUsecase getPopularMoviesUsecase,
    required GetTopRatedMoviesUsecase getTopRatedMoviesUsecase,
  }) {
    final BehaviorSubject<List<Movie>> nowPlayingMoviesSubject =
        BehaviorSubject<List<Movie>>.seeded(<Movie>[]);

    final BehaviorSubject<List<Movie>> popularMoviesSubject =
        BehaviorSubject<List<Movie>>.seeded(<Movie>[]);

    final BehaviorSubject<List<Movie>> topRatedMoviesSubject =
        BehaviorSubject<List<Movie>>.seeded(<Movie>[]);

    final BehaviorSubject<RequestState> nowPlayingState =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<RequestState> popularState =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<RequestState> topRatedState =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    getCurrentNowPlaying() => nowPlayingMoviesSubject.value;

    return MovieListBloc._(
      getNowPlayingMoviesUsecase: getNowPlayingMoviesUsecase,
      getPopularMoviesUsecase: getPopularMoviesUsecase,
      getTopRatedMoviesUsecase: getTopRatedMoviesUsecase,
      addNowPlayingMovies: nowPlayingMoviesSubject.add,
      addPopularMovies: popularMoviesSubject.add,
      addTopRatedMovies: topRatedMoviesSubject.add,
      nowPlayingMoviesStream: nowPlayingMoviesSubject.stream,
      popularMoviesStream: popularMoviesSubject.stream,
      topRatedMoviesStream: topRatedMoviesSubject.stream,
      nowPlayingMovies: getCurrentNowPlaying,
      addNowPlayingState: nowPlayingState.add,
      addPopularMoviesState: popularState.add,
      addTopRatedMoviesState: topRatedState.add,
      nowPlayingStateStream: nowPlayingState.stream,
      popularMoviesStateStream: popularState.stream,
      topRatedMoviesStateStream: topRatedState.stream,
      whatToDispose: () {
        nowPlayingMoviesSubject.close();
        popularMoviesSubject.close();
        topRatedMoviesSubject.close();
        nowPlayingState.close();
        popularState.close();
        topRatedState.close();
      },
    );
  }

  final void Function() whatToDispose;

  final Function1<List<Movie>, void> addNowPlayingMovies;
  final Stream<List<Movie>> nowPlayingMoviesStream;
  final Function0<List<Movie>> nowPlayingMovies;

  final Function1<RequestState, void> addNowPlayingState;
  final Stream<RequestState> nowPlayingStateStream;

  final Function1<List<Movie>, void> addPopularMovies;
  Stream<List<Movie>> popularMoviesStream;

  final Function1<RequestState, void> addPopularMoviesState;
  Stream<RequestState> popularMoviesStateStream;

  final Function1<List<Movie>, void> addTopRatedMovies;
  Stream<List<Movie>> topRatedMoviesStream;

  final Function1<RequestState, void> addTopRatedMoviesState;
  Stream<RequestState> topRatedMoviesStateStream;

  final GetNowPlayingMoviesUsecase getNowPlayingMoviesUsecase;
  final GetPopularMoviesUsecase getPopularMoviesUsecase;
  final GetTopRatedMoviesUsecase getTopRatedMoviesUsecase;

  Future<void> fetchNowPlayingMovies() async {
    addNowPlayingState(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getNowPlayingMoviesUsecase.execute();
    result.fold(
      (Failure failure) {
        addNowPlayingState(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        addNowPlayingState(RequestState.loaded);
        addNowPlayingMovies.call(moviesData);
      },
    );
  }

  Future<void> fetchPopularMovies() async {
    addPopularMoviesState(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getPopularMoviesUsecase.execute();
    result.fold(
      (Failure failure) {
        addPopularMoviesState(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        addPopularMoviesState(RequestState.loaded);
        addPopularMovies(moviesData);
      },
    );
  }

  Future<void> fetchTopRatedMovies() async {
    addTopRatedMoviesState(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getTopRatedMoviesUsecase.execute();
    result.fold(
      (Failure failure) {
        addTopRatedMoviesState(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        addTopRatedMoviesState(RequestState.loaded);
        addTopRatedMovies(moviesData);
      },
    );
  }

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
