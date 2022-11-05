import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/usecases/get_tv_detail_usecase.dart';
import '../../domain/usecases/get_tv_recommendations_usecase.dart';
import '../../domain/usecases/get_tv_watchlist_status_usecase.dart';
import '../../domain/usecases/remove_watchlist_tv_usecase.dart';
import '../../domain/usecases/save_watchlist_tv_usecase.dart';

class TvDetailBloc extends BaseBloc {
  TvDetailBloc({
    required this.getTvDetailUsecase,
    required this.getTvRecommendationsUsecase,
    required this.getWatchListStatusUsecase,
    required this.saveWatchlistUsecase,
    required this.removeWatchlistUsecase,
  });
  static const String watchlistAddSuccessMessage = 'Added to watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from watchlist';

  final GetTvDetailUsecase getTvDetailUsecase;
  final GetTvRecommendationsUsecase getTvRecommendationsUsecase;
  final GetTvWatchlistStatusUsecase getWatchListStatusUsecase;
  final SaveWatchlistTvUsecase saveWatchlistUsecase;
  final RemoveWatchlistTvUsecase removeWatchlistUsecase;

  final BehaviorSubject<TvDetail?> _tv =
      BehaviorSubject<TvDetail?>.seeded(null);
  Stream<TvDetail?> get tv => _tv.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _tvState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get tvStateStream => _tvState.stream.asBroadcastStream();

  final BehaviorSubject<List<Tv>> _recommendations =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get recommendationsStream =>
      _recommendations.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _recommendationsState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get recommendationsStateStream =>
      _recommendationsState.stream.asBroadcastStream();

  final BehaviorSubject<bool> _isAddedToWatchlist =
      BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isAddedToWatchlistStream =>
      _isAddedToWatchlist.stream.asBroadcastStream();
  bool get isAddedToWatchlist => _isAddedToWatchlist.value;

  final BehaviorSubject<String> _watchlistMessage =
      BehaviorSubject<String>.seeded('');
  Stream<String> get watchlistMessageStream =>
      _watchlistMessage.stream.asBroadcastStream();
  String get watchlistMessage => _watchlistMessage.value;

  Future<void> fetchTvDetail(int id) async {
    _tvState.add(RequestState.loading);

    final Either<Failure, TvDetail> detailResult =
        await getTvDetailUsecase.execute(id);
    final Either<Failure, List<Tv>> recommendationsResult =
        await getTvRecommendationsUsecase.execute(id);

    detailResult.fold(
      (Failure failure) {
        _tvState.add(RequestState.error);
        message.add(failure.message);
      },
      (TvDetail tv) {
        _recommendationsState.add(RequestState.loading);
        _tvState.add(RequestState.loaded);
        _tv.add(tv);
        recommendationsResult.fold(
          (Failure failure) {
            _recommendationsState.add(RequestState.error);
            message.add(failure.message);
          },
          (List<Tv> tvs) {
            _recommendationsState.add(RequestState.loaded);
            _recommendations.add(tvs);
          },
        );
      },
    );
  }

  Future<void> addToWatchlist(TvDetail tv) async {
    final Either<Failure, String> result =
        await saveWatchlistUsecase.execute(tv);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage.add(failure.message);
      },
      (String successMessage) async {
        _watchlistMessage.add(successMessage);
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final Either<Failure, String> result =
        await removeWatchlistUsecase.execute(tv);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage.add(failure.message);
      },
      (String successMessage) async {
        _watchlistMessage.add(successMessage);
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final bool result = await getWatchListStatusUsecase.execute(id);
    _isAddedToWatchlist.add(result);
  }

  @override
  void dispose() {
    _tv.close();
    _tvState.close();
    _recommendations.close();
    _recommendationsState.close();
    _isAddedToWatchlist.close();
    _watchlistMessage.close();
    super.dispose();
  }
}
