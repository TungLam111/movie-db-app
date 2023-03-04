import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie_detail.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_detail_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_recommendations_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_watchlist_status_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/remove_watchlist_movie_usecase.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/save_watchlist_movie.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class MovieDetailBloc extends BaseBloc {
  factory MovieDetailBloc({
    required int movieId,
    required GetMovieDetailUsecase getMovieDetail,
    required GetMovieRecommendationsUsecase getMovieRecommendations,
    required GetMovieWatchlistStatusUsecase getWatchListStatus,
    required SaveWatchlistMovieUsecase saveWatchlist,
    required RemoveWatchlistMovieUsecase removeWatchlist,
  }) {
    final BehaviorSubject<void> movieSubject =
        BehaviorSubject<void>.seeded(null);

    final BehaviorSubject<RequestState> movieStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<LoadType> suggestSubject =
        BehaviorSubject<LoadType>.seeded(LoadType.load);
    final BehaviorSubject<RequestState> suggestStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<void> statusSubject =
        BehaviorSubject<void>.seeded(null);
    final BehaviorSubject<RequestState> statusStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    Stream<Object> detailStream = movieSubject
        .exhaustMap(
      (_) => Rx.fromCallable(() => getMovieDetail.execute(movieId))
          .doOnListen(() => movieStateSubject.add(RequestState.loading))
          .doOnError((_, __) {
        movieStateSubject.add(RequestState.error);
      }).doOnData((DataState<MovieDetail> event) {
        if (event.isError()) {
          movieStateSubject.add(RequestState.error);
        } else {
          movieStateSubject.add(RequestState.loaded);
        }
      }),
    )
        .scan(
      (
        Object accumulated,
        DataState<MovieDetail> value,
        int index,
      ) {
        MovieDetail? movie;
        if (value.isSuccess()) {
          movie = value.data;
        }
        return movie!;
      },
      0,
    );

    final Stream<TupleEx2<MovieDetail, RequestState>> detail$ =
        Rx.combineLatest2(
      detailStream,
      movieStateSubject.stream,
      (Object v1, RequestState v2) =>
          TupleEx2<MovieDetail, RequestState>(v1 as MovieDetail, v2),
    ).share();

    // Recommendation movie
    int currentLengthList = 0;
    final Stream<TupleEx2<List<Movie>, RequestState>> suggest$ =
        Rx.combineLatest2(
      suggestSubject
          .map((_) => currentLengthList)
          .exhaustMap(
            (int numberList) => Rx.fromCallable(
              () => getMovieRecommendations.execute(movieId),
            )
                .doOnListen(() => suggestStateSubject.add(RequestState.loading))
                .doOnError((_, __) {
              suggestStateSubject.add(RequestState.error);
            }).doOnData((DataState<List<Movie>> event) {
              if (event.isError()) {
                suggestStateSubject.add(RequestState.error);
              } else {
                suggestStateSubject.add(RequestState.loaded);
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
        },
      ),
      suggestStateSubject.stream,
      (Object v1, RequestState v2) =>
          TupleEx2<List<Movie>, RequestState>(v1 as List<Movie>, v2),
    ).share();

    final Stream<TupleEx2<bool, RequestState>> status$ = Rx.combineLatest2(
      statusSubject
          .exhaustMap(
        (_) => Rx.fromCallable(() => getWatchListStatus.execute(movieId))
            .doOnListen(() => statusStateSubject.add(RequestState.loading))
            .doOnError((_, __) {
          statusStateSubject.add(RequestState.error);
        }).doOnData((bool event) {
          statusStateSubject.add(RequestState.loaded);
        }),
      )
          .scan(
        (
          Object accumulated,
          bool value,
          int index,
        ) {
          return value;
        },
        0,
      ),
      statusStateSubject.stream,
      (Object v1, RequestState v2) =>
          TupleEx2<bool, RequestState>(v1 as bool, v2),
    ).share();

    return MovieDetailBloc._(
      movieId: movieId,
      whatToDispose: () {
        movieSubject.close();
        movieStateSubject.close();
        suggestSubject.close();
        suggestStateSubject.close();
        statusSubject.close();
        statusStateSubject.close();
      },
      loadDetailMovie: () => movieSubject.add(null),
      loadStatus: () => statusSubject.add(null),
      loadSuggest: (LoadType a) {
        suggestSubject.add(a);
      },
      detailStream: detail$,
      statusStream: status$,
      suggestStream: suggest$,
      saveWatchlist: saveWatchlist,
      removeWatchlist: removeWatchlist,
    );
  }
  MovieDetailBloc._({
    required this.detailStream,
    required this.loadDetailMovie,
    required this.whatToDispose,
    required this.loadStatus,
    required this.loadSuggest,
    required this.statusStream,
    required this.suggestStream,
    required this.movieId,
    required this.removeWatchlist,
    required this.saveWatchlist,
  });

  final int movieId;

  static const String watchlistAddSuccessMessage = 'Added to watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from watchlist';

  Future<void> addToWatchlist(MovieDetail movie) async {
    final DataState<String> result = await saveWatchlist.execute(movie);

    if (result.isError()) {
      messageSubject.add(result.err);
    } else {
      messageSubject.add(result.data!);
    }

    await loadStatus.call();
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final DataState<String> result = await removeWatchlist.execute(movie);

    if (result.isError()) {
      messageSubject.add(result.err);
    } else {
      messageSubject.add(result.data!);
    }

    await loadStatus.call();
  }

  final void Function() whatToDispose;

  final FunctionEx0 loadDetailMovie;
  final Stream<TupleEx2<MovieDetail, RequestState>> detailStream;

  final FunctionEx1<LoadType, void> loadSuggest;
  final Stream<TupleEx2<List<Movie>, RequestState>> suggestStream;

  final FunctionEx0 loadStatus;
  final Stream<TupleEx2<bool, RequestState>> statusStream;

  final SaveWatchlistMovieUsecase saveWatchlist;
  final RemoveWatchlistMovieUsecase removeWatchlist;

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}