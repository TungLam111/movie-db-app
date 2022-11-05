import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
import '../../domain/usecases/get_tv_detail_usecase.dart';
import '../../domain/usecases/get_tv_recommendations_usecase.dart';
import '../../domain/usecases/get_tv_watchlist_status_usecase.dart';
import '../../domain/usecases/remove_watchlist_tv_usecase.dart';
import '../../domain/usecases/save_watchlist_tv_usecase.dart';

class TvDetailNotifier extends ChangeNotifier {
  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });
  static const String watchlistAddSuccessMessage = 'Added to watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from watchlist';

  final GetTvDetailUsecase getTvDetail;
  final GetTvRecommendationsUsecase getTvRecommendations;
  final GetTvWatchlistStatusUsecase getWatchListStatus;
  final SaveWatchlistTvUsecase saveWatchlist;
  final RemoveWatchlistTvUsecase removeWatchlist;

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.empty;
  RequestState get tvState => _tvState;

  List<Tv> _recommendations = <Tv>[];
  List<Tv> get recommendations => _recommendations;

  RequestState _recommendationsState = RequestState.empty;
  RequestState get recommendationsState => _recommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.loading;
    notifyListeners();

    final Either<Failure, TvDetail> detailResult =
        await getTvDetail.execute(id);
    final Either<Failure, List<Tv>> recommendationsResult =
        await getTvRecommendations.execute(id);

    detailResult.fold(
      (Failure failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (TvDetail tv) {
        _recommendationsState = RequestState.loading;
        _tvState = RequestState.loaded;
        _tv = tv;
        notifyListeners();
        recommendationsResult.fold(
          (Failure failure) {
            _recommendationsState = RequestState.error;
            _message = failure.message;
          },
          (List<Tv> tvs) {
            _recommendationsState = RequestState.loaded;
            _recommendations = tvs;
          },
        );
        notifyListeners();
      },
    );
  }

  Future<void> addToWatchlist(TvDetail tv) async {
    final Either<Failure, String> result = await saveWatchlist.execute(tv);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage = failure.message;
      },
      (String successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final Either<Failure, String> result = await removeWatchlist.execute(tv);

    await result.fold(
      (Failure failure) async {
        _watchlistMessage = failure.message;
      },
      (String successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final bool result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }
}
