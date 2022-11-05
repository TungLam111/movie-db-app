import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/usecases/get_movie_detail_usecase.dart';
import '../../domain/usecases/get_movie_recommendations_usecase.dart';
import '../../domain/usecases/get_movie_watchlist_status_usecase.dart';
import '../../domain/usecases/remove_watchlist_movie_usecase.dart';
import '../../domain/usecases/save_watchlist_movie.dart';

class MovieDetailNotifier extends ChangeNotifier {
  MovieDetailNotifier({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });
  static const String watchlistAddSuccessMessage = '''Added to watchlist''';
  static const String watchlistRemoveSuccessMessage =
      '''Removed from watchlist''';

  final GetMovieDetailUsecase getMovieDetail;
  final GetMovieRecommendationsUsecase getMovieRecommendations;
  final GetMovieWatchlistStatusUsecase getWatchListStatus;
  final SaveWatchlistMovieUsecase saveWatchlist;
  final RemoveWatchlistMovieUsecase removeWatchlist;

  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  RequestState _movieState = RequestState.empty;
  RequestState get movieState => _movieState;

  List<Movie> _recommendations = <Movie>[];
  List<Movie> get recommendations => _recommendations;

  RequestState _recommendationsState = RequestState.empty;
  RequestState get recommendationsState => _recommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchMovieDetail(int id) async {
    _movieState = RequestState.loading;
    notifyListeners();

    final Either<Failure, MovieDetail> detailResult =
        await getMovieDetail.execute(id);
    final Either<Failure, List<Movie>> recommendationResult =
        await getMovieRecommendations.execute(id);
    detailResult.fold(
      (Failure failure) {
        _movieState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (MovieDetail movie) {
        _recommendationsState = RequestState.loading;
        _movie = movie;
        notifyListeners();
        recommendationResult.fold(
          (Failure failure) {
            _recommendationsState = RequestState.error;
            _message = failure.message;
          },
          (List<Movie> movies) {
            _recommendationsState = RequestState.loaded;
            _recommendations = movies;
          },
        );
        _movieState = RequestState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> addToWatchlist(MovieDetail movie) async {
    final Either<Failure, String> result = await saveWatchlist.execute(movie);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage = failure.message;
      },
      (String successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final Either<Failure, String> result = await removeWatchlist.execute(movie);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage = failure.message;
      },
      (String successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final bool result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
