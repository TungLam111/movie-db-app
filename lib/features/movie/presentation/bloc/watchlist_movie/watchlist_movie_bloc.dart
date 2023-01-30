import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_watchlist_movies_usecase.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistMovieBloc extends BaseBloc {
  WatchlistMovieBloc({required this.getWatchlistMoviesUsecase});
  final GetWatchlistMoviesUsecase getWatchlistMoviesUsecase;

  final BehaviorSubject<List<Movie>> _watchlistMoviesSubject =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get watchlistMoviesStream =>
      _watchlistMoviesSubject.stream;

  final BehaviorSubject<RequestState> _watchlistStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get watchlistStateStream =>
      _watchlistStateSubject.stream;

  Future<void> fetchWatchlistMovies() async {
    _watchlistStateSubject.add(RequestState.loading);

    final Either<Failure, List<Movie>> result =
        await getWatchlistMoviesUsecase.execute();

    result.fold(
      (Failure failure) {
        _watchlistStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (List<Movie> moviesData) {
        _watchlistStateSubject.add(RequestState.loaded);
        _watchlistMoviesSubject.add(moviesData);
        log(moviesData.length.toString());
      },
    );
  }

  @override
  void dispose() {
    _watchlistMoviesSubject.close();
    _watchlistStateSubject.close();
    super.dispose();
  }
}
