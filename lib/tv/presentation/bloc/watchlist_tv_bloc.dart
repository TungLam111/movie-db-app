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

  final BehaviorSubject<List<Tv>> _watchlistTvs =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);

  Stream<List<Tv>> get watchlistTvsStream =>
      _watchlistTvs.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _watchlistState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get watchlistStateStream =>
      _watchlistState.stream.asBroadcastStream();

  Future<void> fetchWatchlistTvs() async {
    _watchlistState.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getWatchlistTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _watchlistState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Tv> watchlistTvs) {
        _watchlistState.add(RequestState.loaded);
        _watchlistTvs.add(watchlistTvs);
      },
    );
  }

  @override
  void dispose() {
    _watchlistState.close();
    _watchlistTvs.close();
    super.dispose();
  }
}
