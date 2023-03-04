import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_top_rated_movies_usecase.dart';
import 'package:rxdart/rxdart.dart';

class TopRatedMoviesBloc extends BaseBloc {
  TopRatedMoviesBloc._({
    required this.tupleStream,
    required this.loadMovies,
    required this.whatToDispose,
  });

  factory TopRatedMoviesBloc({
    required GetTopRatedMoviesUsecase getTopRatedMovies,
  }) {
    final BehaviorSubject<RequestState> stateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<void> moviesSubject =
        BehaviorSubject<void>.seeded(null);

    int currentLengthList = 0;
    int currentPage = 1;

    final Stream<TupleEx2<List<Movie>, RequestState>> loadMovieStream =
        Rx.combineLatest2(
      moviesSubject
          .map((_) => currentLengthList)
          .exhaustMap(
            (int numberList) =>
                Rx.fromCallable(() => getTopRatedMovies.execute(currentPage))
                    .doOnListen(() => stateSubject.add(RequestState.loading))
                    .doOnError((_, __) {
              stateSubject.add(RequestState.error);
            }).doOnData((DataState<List<Movie>> event) {
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
          DataState<List<Movie>> value,
          int index,
        ) {
          List<Movie> temp = <Movie>[];
          if (value.isSuccess()) {
            temp = value.data!;
          }
          if (accumulated is List) {
            return <Movie>[...(accumulated as List<Movie>), ...temp];
          }
          return <Movie>[...temp];
        },
        0,
      ).doOnData(
        (Object list) {
          currentLengthList = (list as List<Movie>).length;
          currentPage = currentPage + 1;
        },
      ),
      stateSubject.stream,
      (Object v1, RequestState v2) =>
          TupleEx2<List<Movie>, RequestState>(v1 as List<Movie>, v2),
    ).share();

    return TopRatedMoviesBloc._(
      tupleStream: loadMovieStream,
      loadMovies: () => moviesSubject.add(null),
      whatToDispose: () {
        stateSubject.close();
        moviesSubject.close();
      },
    );
  }

  final Stream<TupleEx2<List<Movie>, RequestState>> tupleStream;
  final FunctionEx0 loadMovies;
  final void Function() whatToDispose;

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
