import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie_detail.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_detail_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_recommendations_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/get_movie_watchlist_status_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/remove_watchlist_movie_usecase.dart';
import 'package:mock_bloc_stream/movie/domain/usecases/save_watchlist_movie.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc extends BaseBloc {
  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });
  static const String watchlistAddSuccessMessage = 'Added to watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from watchlist';

  final GetMovieDetailUsecase getMovieDetail;
  final GetMovieRecommendationsUsecase getMovieRecommendations;
  final GetMovieWatchlistStatusUsecase getWatchListStatus;
  final SaveWatchlistMovieUsecase saveWatchlist;
  final RemoveWatchlistMovieUsecase removeWatchlist;

  final BehaviorSubject<MovieDetail?> _movieSubject =
      BehaviorSubject<MovieDetail?>.seeded(null);
  Stream<MovieDetail?> get getMovieDetailStream =>
      _movieSubject.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _movieStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get movieStateStream =>
      _movieStateSubject.stream.asBroadcastStream();

  final BehaviorSubject<List<Movie>> _recommendationsSubjectSubject =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get recommendationStream =>
      _recommendationsSubjectSubject.stream.asBroadcastStream();
  List<Movie> get recommendationsValue => _recommendationsSubjectSubject.value;

  final BehaviorSubject<RequestState> _recommendationsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get recommendationsStateStream =>
      _recommendationsStateSubject.stream.asBroadcastStream();

  final BehaviorSubject<bool> _isAddedToWatchlistSubject =
      BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isAddedToWatchlistStream =>
      _isAddedToWatchlistSubject.stream.asBroadcastStream();
  bool get isAddedToWatchlistValue => _isAddedToWatchlistSubject.value;

  final BehaviorSubject<String> _watchlistMessageSubject =
      BehaviorSubject<String>.seeded('');
  Stream<String> get watchlistMessageStream =>
      _watchlistMessageSubject.stream.asBroadcastStream();
  String get watchlistMessageValue => _watchlistMessageSubject.value;

  Future<void> fetchMovieDetail(int id) async {
    _movieStateSubject.add(RequestState.loading);

    final Either<Failure, MovieDetail> detailResult =
        await getMovieDetail.execute(id);
    final Either<Failure, List<Movie>> recommendationResult =
        await getMovieRecommendations.execute(id);

    detailResult.fold(
      (Failure failure) {
        _movieStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (MovieDetail movie) {
        _recommendationsStateSubject.add(RequestState.loading);
        _movieSubject.add(movie);

        recommendationResult.fold(
          (Failure failure) {
            _recommendationsStateSubject.add(RequestState.error);
            messageSubject.add(failure.message);
          },
          (List<Movie> movies) {
            _recommendationsStateSubject.add(RequestState.loaded);
            _recommendationsSubjectSubject.add(movies);
          },
        );
        _movieStateSubject.add(RequestState.loaded);
      },
    );
  }

  Future<void> addToWatchlist(MovieDetail movie) async {
    final Either<Failure, String> result = await saveWatchlist.execute(movie);

    await result.fold(
      (Failure failure) async {
        _watchlistMessageSubject.add(failure.message);
      },
      (String successMessage) async {
        _watchlistMessageSubject.add(successMessage);
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final Either<Failure, String> result = await removeWatchlist.execute(movie);

    await result.fold(
      (Failure failure) async {
        _watchlistMessageSubject.add(failure.message);
      },
      (String successMessage) async {
        _watchlistMessageSubject.add(successMessage);
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final bool result = await getWatchListStatus.execute(id);
    _isAddedToWatchlistSubject.add(result);
  }

  @override
  void dispose() {
    _movieSubject.close();
    _movieStateSubject.close();
    _recommendationsSubjectSubject.close();
    _recommendationsStateSubject.close();
    _isAddedToWatchlistSubject.close();
    _watchlistMessageSubject.close();
    super.dispose();
  }
}
