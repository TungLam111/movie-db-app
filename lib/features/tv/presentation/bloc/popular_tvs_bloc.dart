import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/config/env/logger_config.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_popular_tvs_usecase.dart';

class PopularTvsBloc extends BaseBloc {
  PopularTvsBloc._({
    required this.whatToDispose,
    required this.tupleStream,
    required this.loadTvs,
  });
  factory PopularTvsBloc({
    required GetPopularTvsUsecase getPopularTvsUsecase,
  }) {
    final BehaviorSubject<LoadType> tvsSubject =
        BehaviorSubject<LoadType>.seeded(LoadType.refresh);

    final BehaviorSubject<RequestState> stateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    int currentLengthList = 0;
    int currentPage = 1;

    Stream<Object> tvsStream = tvsSubject
        .doOnData((LoadType event) {
          if (event == LoadType.load) {
          } else {
            currentPage = 1;
          }
        })
        .exhaustMap(
          (LoadType type) =>
              fetchData(type, getPopularTvsUsecase.execute, currentPage)
                  .doOnListen(() => stateSubject.add(RequestState.loading))
                  .doOnError((_, __) {
            stateSubject.add(RequestState.error);
          }).doOnData((Either<Failure, List<Tv>> event) {
            event.fold(
              (Failure failure) {
                stateSubject.add(RequestState.error);
              },
              (List<Tv> tvsData) {
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
            if (currentPage > 1) {
              return <Tv>[...(accumulated as List<Tv>), ...temp];
            }
            return <Tv>[...temp];
          },
          0,
        )
        .doOnData(
          (Object list) {
            currentLengthList = (list as List<Tv>).length;
            currentPage = currentPage + 1;
            logg(currentLengthList);
          },
        );

    final Stream<TupleEx2<List<Tv>, RequestState>> loadStream =
        Rx.combineLatest2(
      tvsStream,
      stateSubject.stream,
      (Object v1, RequestState v2) =>
          Tuple2<List<Tv>, RequestState>(v1 as List<Tv>, v2),
    ).share();

    return PopularTvsBloc._(
      whatToDispose: () {
        tvsSubject.close();
        stateSubject.close();
      },
      tupleStream: loadStream,
      loadTvs: (LoadType type) {
        tvsSubject.add(type);
      },
    );
  }

  static Stream<Either<Failure, List<Tv>>> fetchData(
    LoadType event,
    Future<Either<Failure, List<Tv>>> Function(int?) f,
    int current,
  ) {
    if (event == LoadType.refresh) {
      return Rx.fromCallable(
        () => f.call(1),
      );
    }
    return Rx.fromCallable(
      () => f.call(current),
    );
  }

  final void Function() whatToDispose;
  final Stream<TupleEx2<List<Tv>, RequestState>> tupleStream;
  final Function1<LoadType, void> loadTvs;

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
