import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_watchlist_tvs_usecase.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistTvBloc extends BaseBloc {
  factory WatchlistTvBloc({
    required GetWatchlistTvsUsecase getWatchlistTvsUsecase,
  }) {
    final BehaviorSubject<RequestState> stateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.loading);

    final BehaviorSubject<void> tvsSubject = BehaviorSubject<void>.seeded(null);
    int currentLengthList = 0;
    int currentPage = 1;

    final Stream<TupleEx2<List<Tv>, RequestState>> loadTvStream =
        Rx.combineLatest2(
      tvsSubject
          .map((_) => currentLengthList)
          .exhaustMap(
            (int numberList) => Rx.fromCallable(
              () => getWatchlistTvsUsecase.execute(currentPage),
            )
                .doOnListen(() => stateSubject.add(RequestState.loading))
                .doOnError((_, __) {
              stateSubject.add(RequestState.error);
            }).doOnData((Either<Failure, List<Tv>> event) {
              event.fold(
                (Failure failure) {
                  stateSubject.add(RequestState.error);
                },
                (List<Tv> moviesData) {
                  stateSubject.add(RequestState.loaded);
                },
              );
            }),
          )
          .scan(
        (
          Object accumulated,
          Either<Failure, List<Tv>> value,
          int index,
        ) {
          List<Tv> temp = <Tv>[];
          value.fold(
            (Failure failure) {},
            (List<Tv> tvsData) {
              temp = tvsData;
            },
          );
          if (accumulated is List) {
            return <Tv>[...(accumulated as List<Tv>), ...temp];
          }
          return <Tv>[...temp];
        },
        0,
      ).doOnData(
        (Object list) {
          currentLengthList = (list as List<Tv>).length;
          currentPage = currentPage + 1;
        },
      ),
      stateSubject.stream,
      (Object v1, RequestState v2) =>
          Tuple2<List<Tv>, RequestState>(v1 as List<Tv>, v2),
    ).share();

    return WatchlistTvBloc._(
      tupleStream: loadTvStream,
      loadTvs: () => tvsSubject.add(null),
      whatToDispose: () {
        stateSubject.close();
        tvsSubject.close();
      },
    );
  }
  WatchlistTvBloc._({
    required this.tupleStream,
    required this.loadTvs,
    required this.whatToDispose,
  });

  final Stream<TupleEx2<List<Tv>, RequestState>> tupleStream;
  final Function0 loadTvs;
  final void Function() whatToDispose;

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
