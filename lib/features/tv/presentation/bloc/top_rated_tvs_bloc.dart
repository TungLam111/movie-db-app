import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/core/config/env/logger_config.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_top_rated_tvs_usecase.dart';

class TopRatedTvsBloc extends BaseBloc {
  TopRatedTvsBloc._({
    required this.whatToDispose,
    required this.tupleStream,
    required this.loadTvs,
  });

  factory TopRatedTvsBloc({
    required GetTopRatedTvsUsecase getTopRatedTvsUsecase,
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
              fetchData(type, getTopRatedTvsUsecase.execute, currentPage)
                  .doOnListen(() => stateSubject.add(RequestState.loading))
                  .doOnError((_, __) {
            stateSubject.add(RequestState.error);
          }).doOnData((DataState<List<Tv>> event) {
            if (event.isError()) {
              stateSubject.add(RequestState.error);
            } else {
              stateSubject.add(RequestState.loaded);
            }
          }),
        )
        .scan(
          (
            Object accumulated,
            DataState<List<Tv>> value,
            int index,
          ) {
            List<Tv> temp = <Tv>[];
            if (value.isSuccess()) {
              temp = value.data!;
            }

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
          TupleEx2<List<Tv>, RequestState>(v1 as List<Tv>, v2),
    ).share();

    return TopRatedTvsBloc._(
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

  static Stream<DataState<List<Tv>>> fetchData(
    LoadType event,
    Future<DataState<List<Tv>>> Function(int?) f,
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
  final FunctionEx1<LoadType, void> loadTvs;

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
