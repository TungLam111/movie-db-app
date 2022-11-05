import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:rxdart/rxdart.dart';

class TopRatedMoviesBloc extends BaseBloc {
  TopRatedMoviesBloc({required this.getTopRatedMovies});
  final GetTopRatedMoviesUsecase getTopRatedMovies;

  final BehaviorSubject<RequestState> _state =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get stateStream => _state.stream;

  final BehaviorSubject<List<Movie>> _movies =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get moviesStream => _movies.stream.asBroadcastStream();

  Future<void> fetchTopRatedMovies() async {
    _state.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getTopRatedMovies.execute();

    result.fold(
      (Failure failure) {
        message.add(failure.message);
        _state.add(RequestState.error);
      },
      (List<Movie> moviesData) {
        _movies.add(moviesData);
        _state.add(RequestState.loaded);
      },
    );
  }

  @override
  void dispose() {
    _state.close();
    _movies.close();
    super.dispose();
  }
}
