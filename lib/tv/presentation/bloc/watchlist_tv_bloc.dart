import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/tv/domain/usecases/get_watchlist_tvs_usecase.dart';

class WatchlistTvBloc extends BaseBloc {
  WatchlistTvBloc({required this.getWatchlistTvsUsecase});
  final GetWatchlistTvsUsecase getWatchlistTvsUsecase;

  final BehaviorSubject<List<Tv>> _watchlistTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get watchlistTvsStream =>
      _watchlistTvsSubject.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _watchlistStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get watchlistStateStream =>
      _watchlistStateSubject.stream.asBroadcastStream();

  Future<void> fetchWatchlistTvs() async {
    _watchlistStateSubject.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getWatchlistTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _watchlistStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (List<Tv> watchlistTvs) {
        _watchlistStateSubject.add(RequestState.loaded);
        _watchlistTvsSubject.add(watchlistTvs);
      },
    );
  }

  @override
  void dispose() {
    _watchlistStateSubject.close();
    _watchlistTvsSubject.close();
    super.dispose();
  }
}
