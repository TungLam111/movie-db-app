import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_popular_movies_usecase.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class PopularMoviesBloc {
  PopularMoviesBloc(this._getPopularMoviesUsecase);
  final GetPopularMoviesUsecase _getPopularMoviesUsecase;

  final BehaviorSubject<RequestState> _state =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get getWatchlistMovieStateStream =>
      _state.stream.asBroadcastStream();

  final BehaviorSubject<List<Movie>> _movies =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get getMoviesStream => _movies.stream.asBroadcastStream();

  final BehaviorSubject<String> _message = BehaviorSubject<String>.seeded('');
  String get currentMessage => _message.value;

  Future<void> fetchPopularMovies() async {
    _state.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await _getPopularMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _message.add(failure.message);
        _state.add(RequestState.error);
      },
      (List<Movie> moviesData) {
        _movies.sink.add(moviesData);
        _state.sink.add(RequestState.loaded);
      },
    );
  }

  void dispose() {
    _state.close();
    _movies.close();
  }
}
