import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_watchlist_movies_usecase.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistMovieBloc extends BaseBloc {
  factory WatchlistMovieBloc({
    required GetWatchlistMoviesUsecase getWatchlistMoviesUsecase,
  }) {
    final BehaviorSubject<RequestState> stateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.loading);

    final BehaviorSubject<void> moviesSubject =
        BehaviorSubject<void>.seeded(null);
    int currentLengthList = 0;
    int currentPage = 1;

    final Stream<TupleEx2<List<Movie>, RequestState>> loadMovieStream =
        Rx.combineLatest2(
      moviesSubject
          .map((_) => currentLengthList)
          .exhaustMap(
            (int numberList) => Rx.fromCallable(
              () => getWatchlistMoviesUsecase.execute(currentPage),
            )
                .doOnListen(() => stateSubject.add(RequestState.loading))
                .doOnError((_, __) {
              stateSubject.add(RequestState.error);
            }).doOnData((Either<Failure, List<Movie>> event) {
              event.fold(
                (Failure failure) {
                  stateSubject.add(RequestState.error);
                },
                (List<Movie> moviesData) {
                  stateSubject.add(RequestState.loaded);
                },
              );
            }),
          )
          .scan(
        (
          Object accumulated,
          Either<Failure, List<Movie>> value,
          int index,
        ) {
          List<Movie> temp = <Movie>[];
          value.fold(
            (Failure failure) {},
            (List<Movie> moviesData) {
              temp = moviesData;
            },
          );
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
          Tuple2<List<Movie>, RequestState>(v1 as List<Movie>, v2),
    ).share();

    return WatchlistMovieBloc._(
      tupleStream: loadMovieStream,
      loadMovies: () => moviesSubject.add(null),
      whatToDispose: () {
        stateSubject.close();
        moviesSubject.close();
      },
    );
  }
  WatchlistMovieBloc._({
    required this.tupleStream,
    required this.loadMovies,
    required this.whatToDispose,
  });

  final Stream<TupleEx2<List<Movie>, RequestState>> tupleStream;
  final Function0 loadMovies;
  final void Function() whatToDispose;

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
