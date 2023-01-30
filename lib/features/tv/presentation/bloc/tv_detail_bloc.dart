import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
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
  final GetTvDetailUsecase getTvDetailUsecase;
  final GetTvRecommendationsUsecase getTvRecommendationsUsecase;
  final GetTvWatchlistStatusUsecase getWatchListStatusUsecase;
  final SaveWatchlistTvUsecase saveWatchlistUsecase;
  final RemoveWatchlistTvUsecase removeWatchlistUsecase;

  final BehaviorSubject<TvDetail?> _tvSubject =
      BehaviorSubject<TvDetail?>.seeded(null);
  Stream<TvDetail?> get tv => _tvSubject.stream;

  final BehaviorSubject<RequestState> _tvStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get tvStateStream =>
      _tvStateSubject.stream;

  final BehaviorSubject<List<Tv>> _recommendationsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get recommendationsStream =>
      _recommendationsSubject.stream;

  final BehaviorSubject<RequestState> _recommendationsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get recommendationsStateStream =>
      _recommendationsStateSubject.stream;

  final BehaviorSubject<bool> _isAddedToWatchlistSubject =
      BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isAddedToWatchlistStream =>
      _isAddedToWatchlistSubject.stream;
  bool get isAddedToWatchlist => _isAddedToWatchlistSubject.value;

  Future<void> fetchTvDetail(int id) async {
    _tvStateSubject.add(RequestState.loading);

    final Either<Failure, TvDetail> detailResult =
        await getTvDetailUsecase.execute(id);
    final Either<Failure, List<Tv>> recommendationsResult =
        await getTvRecommendationsUsecase.execute(id);

    detailResult.fold(
      (Failure failure) {
        _tvStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (TvDetail tv) {
        _recommendationsStateSubject.add(RequestState.loading);
        _tvStateSubject.add(RequestState.loaded);
        _tvSubject.add(tv);
        recommendationsResult.fold(
          (Failure failure) {
            _recommendationsStateSubject.add(RequestState.error);
            messageSubject.add(failure.message);
          },
          (List<Tv> tvs) {
            _recommendationsStateSubject.add(RequestState.loaded);
            _recommendationsSubject.add(tvs);
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
        messageSubject.add(failure.message);
      },
      (String successMessage) async {
        messageSubject.add(successMessage);
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final Either<Failure, String> result =
        await removeWatchlistUsecase.execute(tv);

    await result.fold(
      (Failure failure) async {
        messageSubject.add(failure.message);
      },
      (String successMessage) async {
        messageSubject.add(successMessage);
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final bool result = await getWatchListStatusUsecase.execute(id);
    _isAddedToWatchlistSubject.add(result);
  }

  @override
  void dispose() {
    _tvSubject.close();
    _tvStateSubject.close();
    _recommendationsSubject.close();
    _recommendationsStateSubject.close();
    _isAddedToWatchlistSubject.close();
    messageSubject.close();
    super.dispose();
  }
}
