import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_popular_movies_usecase.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class PopularMoviesBloc extends BaseBloc {
  PopularMoviesBloc(this._getPopularMoviesUsecase);
  final GetPopularMoviesUsecase _getPopularMoviesUsecase;

  final BehaviorSubject<RequestState> _stateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get getWatchlistMovieStateStream =>
      _stateSubject.stream.asBroadcastStream();

  final BehaviorSubject<List<Movie>> _moviesSubject =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get getMoviesStream =>
      _moviesSubject.stream.asBroadcastStream();

  final BehaviorSubject<String> _messageSubject =
      BehaviorSubject<String>.seeded('');
  String get currentMessage => _messageSubject.value;

  Future<void> fetchPopularMovies() async {
    _stateSubject.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await _getPopularMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _messageSubject.add(failure.message);
        _stateSubject.add(RequestState.error);
      },
      (List<Movie> moviesData) {
        _moviesSubject.sink.add(moviesData);
        _stateSubject.sink.add(RequestState.loaded);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _stateSubject.close();
    _moviesSubject.close();
  }
}
