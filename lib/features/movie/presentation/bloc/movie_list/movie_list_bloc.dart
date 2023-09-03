import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/core/extension/extension.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/media_image.dart';
import 'package:mock_bloc_stream/features/movie/domain/usecases/get_movie_images_usecase.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies_usecase.dart';
import '../../../domain/usecases/get_popular_movies_usecase.dart';
import '../../../domain/usecases/get_top_rated_movies_usecase.dart';

class MovieListBloc extends BaseBloc {
  MovieListBloc._({
    required this.getNowPlayingMoviesUsecase,
    required this.getPopularMoviesUsecase,
    required this.getTopRatedMoviesUsecase,
    required this.addNowPlayingMovies,
    required this.addPopularMovies,
    required this.addTopRatedMovies,
    required this.nowPlayingMoviesStream,
    required this.popularMoviesStream,
    required this.topRatedMoviesStream,
    required this.nowPlayingMoviesF,
    required this.addNowPlayingState,
    required this.addPopularMoviesState,
    required this.addTopRatedMoviesState,
    required this.nowPlayingStateStream,
    required this.popularMoviesStateStream,
    required this.topRatedMoviesStateStream,
    required this.getMovieImagesUsecase,
    required this.whatToDispose,
    required this.getMediaImageStream,
    required this.addMediaImages,
    required this.addMovieImagesState,
    required this.getMovieImagesStateStream,
  });

  factory MovieListBloc({
    required GetNowPlayingMoviesUsecase getNowPlayingMoviesUsecase,
    required GetPopularMoviesUsecase getPopularMoviesUsecase,
    required GetTopRatedMoviesUsecase getTopRatedMoviesUsecase,
    required GetMovieImagesUsecase getMovieImagesUsecase,
  }) {
    final BehaviorSubject<List<Movie>> nowPlayingMoviesSubject =
        BehaviorSubject<List<Movie>>.seeded(<Movie>[]);

    final BehaviorSubject<List<Movie>> popularMoviesSubject =
        BehaviorSubject<List<Movie>>.seeded(<Movie>[]);

    final BehaviorSubject<List<Movie>> topRatedMoviesSubject =
        BehaviorSubject<List<Movie>>.seeded(<Movie>[]);

    final BehaviorSubject<RequestState> nowPlayingStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<RequestState> popularStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<RequestState> topRatedStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    final BehaviorSubject<MediaImage?> movieImagesSubject =
        BehaviorSubject<MediaImage?>.seeded(null);

    final BehaviorSubject<RequestState> movieImagesStateSubject =
        BehaviorSubject<RequestState>.seeded(RequestState.empty);

    getCurrentNowPlaying() => nowPlayingMoviesSubject.value;

    return MovieListBloc._(
      getNowPlayingMoviesUsecase: getNowPlayingMoviesUsecase,
      getPopularMoviesUsecase: getPopularMoviesUsecase,
      getTopRatedMoviesUsecase: getTopRatedMoviesUsecase,
      addNowPlayingMovies: nowPlayingMoviesSubject.add,
      addPopularMovies: popularMoviesSubject.add,
      addTopRatedMovies: topRatedMoviesSubject.add,
      nowPlayingMoviesStream: nowPlayingMoviesSubject.stream,
      popularMoviesStream: popularMoviesSubject.stream,
      topRatedMoviesStream: topRatedMoviesSubject.stream,
      nowPlayingMoviesF: () => getCurrentNowPlaying(),
      addNowPlayingState: nowPlayingStateSubject.add,
      addPopularMoviesState: popularStateSubject.add,
      addTopRatedMoviesState: topRatedStateSubject.add,
      nowPlayingStateStream: nowPlayingStateSubject.stream,
      popularMoviesStateStream: popularStateSubject.stream,
      topRatedMoviesStateStream: topRatedStateSubject.stream,
      getMediaImageStream: movieImagesSubject.stream,
      whatToDispose: () {
        nowPlayingMoviesSubject.close();
        popularMoviesSubject.close();
        topRatedMoviesSubject.close();
        nowPlayingStateSubject.close();
        popularStateSubject.close();
        topRatedStateSubject.close();
      },
      addMediaImages: movieImagesSubject.add,
      addMovieImagesState: movieImagesStateSubject.add,
      getMovieImagesStateStream: movieImagesStateSubject.stream,
      getMovieImagesUsecase: getMovieImagesUsecase,
    );
  }

  final void Function() whatToDispose;

  final FunctionEx1<List<Movie>, void> addNowPlayingMovies;
  final Stream<List<Movie>> nowPlayingMoviesStream;
  final FunctionEx0<List<Movie>> nowPlayingMoviesF;

  final FunctionEx1<RequestState, void> addNowPlayingState;
  final Stream<RequestState> nowPlayingStateStream;

  final FunctionEx1<List<Movie>, void> addPopularMovies;
  Stream<List<Movie>> popularMoviesStream;

  final FunctionEx1<RequestState, void> addPopularMoviesState;
  Stream<RequestState> popularMoviesStateStream;

  final FunctionEx1<List<Movie>, void> addTopRatedMovies;
  Stream<List<Movie>> topRatedMoviesStream;

  final FunctionEx1<RequestState, void> addTopRatedMoviesState;
  Stream<RequestState> topRatedMoviesStateStream;

  final FunctionEx1<MediaImage?, void> addMediaImages;
  Stream<MediaImage?> getMediaImageStream;

  final FunctionEx1<RequestState, void> addMovieImagesState;
  Stream<RequestState> getMovieImagesStateStream;

  final GetNowPlayingMoviesUsecase getNowPlayingMoviesUsecase;
  final GetPopularMoviesUsecase getPopularMoviesUsecase;
  final GetTopRatedMoviesUsecase getTopRatedMoviesUsecase;
  final GetMovieImagesUsecase getMovieImagesUsecase;

  Future<void> fetchNowPlayingMovies() async {
    addNowPlayingState(RequestState.loading);

    final DataState<List<Movie>> result =
        await getNowPlayingMoviesUsecase.execute();

    if (result.isError()) {
      addNowPlayingState(RequestState.error);
      messageSubject.add(result.err);
    } else {
      addNowPlayingState(RequestState.loaded);
      addNowPlayingMovies(result.data!);
    }
  }

  Future<void> fetchPopularMovies() async {
    addPopularMoviesState(RequestState.loading);

    final DataState<List<Movie>> result =
        await getPopularMoviesUsecase.execute(1);
    if (result.isError()) {
      addPopularMoviesState(RequestState.error);
      messageSubject.add(result.err);
    } else {
      addPopularMoviesState(RequestState.loaded);
      addPopularMovies(result.data!);
    }
  }

  Future<void> fetchTopRatedMovies() async {
    addTopRatedMoviesState(RequestState.loading);

    final DataState<List<Movie>> result =
        await getTopRatedMoviesUsecase.execute(1);
    if (result.isError()) {
      addTopRatedMoviesState(RequestState.error);
      messageSubject.add(result.err);
    } else {
      addTopRatedMoviesState(RequestState.loaded);
      addTopRatedMovies(result.data!);
    }
  }

  Future<void> fetchMovieImages(int id) async {
    addMovieImagesState(RequestState.loading);

    final DataState<MediaImage> result =
        await getMovieImagesUsecase.execute(id);
    if (result.isError()) {
      addMovieImagesState(RequestState.error);
      messageSubject.add(result.err);
    } else {
      addMovieImagesState(RequestState.loaded);
      addMediaImages(result.data);
    }
  }

  @override
  void dispose() {
    whatToDispose.call();
    super.dispose();
  }
}
