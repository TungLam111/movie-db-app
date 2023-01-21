import 'package:built_value/built_value.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

part 'state_movie_list.g.dart';

abstract class MovieListState
    implements Built<MovieListState, MovieListStateBuilder> {
  MovieListState._();

  factory MovieListState({
    List<Movie>? nowPlayingMovies = const <Movie>[],
    RequestState? nowPlayingMoviesState = RequestState.empty,
    List<Movie>? popularMovies = const <Movie>[],
    RequestState? popularMoviesState = RequestState.empty,
    List<Movie>? topRatedMovies = const <Movie>[],
    RequestState? topRatedMoviesState = RequestState.empty,
  }) =>
      _$MovieListState._(
        nowPlayingMovies: nowPlayingMovies,
        nowPlayingMoviesState: nowPlayingMoviesState,
        popularMovies: popularMovies,
        popularMoviesState: popularMoviesState,
        topRatedMovies: topRatedMovies,
        topRatedMoviesState: topRatedMoviesState,
      );

  RequestState? get nowPlayingMoviesState;
  RequestState? get popularMoviesState;
  RequestState? get topRatedMoviesState;

  List<Movie>? get nowPlayingMovies;
  List<Movie>? get popularMovies;
  List<Movie>? get topRatedMovies;
}
