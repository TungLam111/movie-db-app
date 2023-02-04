import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
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
  Stream<RequestState> get tvStateStream => _tvStateSubject.stream;

  final BehaviorSubject<List<Tv>> _recommendationsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get recommendationsStream => _recommendationsSubject.stream;

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

    final DataState<TvDetail> detailResult =
        await getTvDetailUsecase.execute(id);
    final DataState<List<Tv>> recommendationsResult =
        await getTvRecommendationsUsecase.execute(id);

    if (detailResult.isError()) {
      _tvStateSubject.add(RequestState.error);
      messageSubject.add(detailResult.err);
    } else {
      _recommendationsStateSubject.add(RequestState.loading);
      _tvStateSubject.add(RequestState.loaded);
      _tvSubject.add(detailResult.data);
      if (recommendationsResult.isError()) {
        _recommendationsStateSubject.add(RequestState.error);
        messageSubject.add(recommendationsResult.err);
      } else {
        _recommendationsStateSubject.add(RequestState.loaded);
        _recommendationsSubject.add(recommendationsResult.data!);
      }
    }
  }

  Future<void> addToWatchlist(TvDetail tv) async {
    final DataState<String> result = await saveWatchlistUsecase.execute(tv);
    if (result.isError()) {
      messageSubject.add(result.err);
    } else {
      messageSubject.add(result.data!);
    }
    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final DataState<String> result = await removeWatchlistUsecase.execute(tv);

    if (result.isError()) {
      messageSubject.add(result.err);
    } else {
      messageSubject.add(result.data!);
    }

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
