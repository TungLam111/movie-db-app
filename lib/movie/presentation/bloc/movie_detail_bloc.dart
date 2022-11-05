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

  final BehaviorSubject<MovieDetail?> _movie =
      BehaviorSubject<MovieDetail?>.seeded(null);
  Stream<MovieDetail?> get getMovieDetailStream =>
      _movie.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _movieState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get movieStateStream =>
      _movieState.stream.asBroadcastStream();

  final BehaviorSubject<List<Movie>> _recommendations =
      BehaviorSubject<List<Movie>>.seeded(<Movie>[]);
  Stream<List<Movie>> get recommendationStream =>
      _recommendations.stream.asBroadcastStream();
  List<Movie> get recommendationsValue => _recommendations.value;

  final BehaviorSubject<RequestState> _recommendationsState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get recommendationsStateStream =>
      _recommendationsState.stream.asBroadcastStream();

  final BehaviorSubject<bool> _isAddedToWatchlist =
      BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isAddedToWatchlistStream =>
      _isAddedToWatchlist.stream.asBroadcastStream();
  bool get isAddedToWatchlistValue => _isAddedToWatchlist.value;

  final BehaviorSubject<String> _watchlistMessage =
      BehaviorSubject<String>.seeded('');
  Stream<String> get watchlistMessageStream =>
      _watchlistMessage.stream.asBroadcastStream();
  String get watchlistMessageValue => _watchlistMessage.value;

  Future<void> fetchMovieDetail(int id) async {
    _movieState.add(RequestState.loading);

    final Either<Failure, MovieDetail> detailResult =
        await getMovieDetail.execute(id);
    final Either<Failure, List<Movie>> recommendationResult =
        await getMovieRecommendations.execute(id);

    detailResult.fold(
      (Failure failure) {
        _movieState.add(RequestState.error);
        message.add(failure.message);
      },
      (MovieDetail movie) {
        _recommendationsState.add(RequestState.loading);
        _movie.add(movie);

        recommendationResult.fold(
          (Failure failure) {
            _recommendationsState.add(RequestState.error);
            message.add(failure.message);
          },
          (List<Movie> movies) {
            _recommendationsState.add(RequestState.loaded);
            _recommendations.add(movies);
          },
        );
        _movieState.add(RequestState.loaded);
      },
    );
  }

  Future<void> addToWatchlist(MovieDetail movie) async {
    final Either<Failure, String> result = await saveWatchlist.execute(movie);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage.add(failure.message);
      },
      (String successMessage) async {
        _watchlistMessage.add(successMessage);
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final Either<Failure, String> result = await removeWatchlist.execute(movie);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage.add(failure.message);
      },
      (String successMessage) async {
        _watchlistMessage.add(successMessage);
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final bool result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist.add(result);
  }

  @override
  void dispose() {
    _movie.close();
    _movieState.close();
    _recommendations.close();
    _recommendationsState.close();
    _isAddedToWatchlist.close();
    _watchlistMessage.close();
    super.dispose();
  }
}
