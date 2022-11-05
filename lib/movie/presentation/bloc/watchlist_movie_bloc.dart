import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_watchlist_movies_usecase.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistMovieBloc extends BaseBloc {
  WatchlistMovieBloc({required this.getWatchlistMoviesUsecase});
  final GetWatchlistMoviesUsecase getWatchlistMoviesUsecase;

  final BehaviorSubject<List<Movie>> _watchlistMovies =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get watchlistMoviesStream =>
      _watchlistMovies.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _watchlistState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get watchlistStateStream =>
      _watchlistState.stream.asBroadcastStream();

  Future<void> fetchWatchlistMovies() async {
    _watchlistState.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getWatchlistMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _watchlistState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Movie> moviesData) {
        _watchlistState.add(RequestState.error);
        _watchlistMovies.add(moviesData);
      },
    );
  }

  @override
  void dispose() {
    _watchlistMovies.close();
    _watchlistState.close();
    super.dispose();
  }
}
