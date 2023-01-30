import 'package:built_value/built_value.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

part 'search_state.g.dart';

abstract class SearchState implements Built<SearchState, SearchStateBuilder> {
  SearchState._();

  factory SearchState({
    List<Movie>? movies = const <Movie>[],
    RequestState? searchMovieState = RequestState.empty,
    String? msgMovie = '',
    List<Tv>? tvs = const <Tv>[],
    RequestState? searchTvState = RequestState.empty,
    String? msgTv = '',
  }) =>
      _$SearchState._(
        movies: movies,
        searchMovieState: searchMovieState,
        tvs: tvs,
        searchTvState: searchTvState,
        msgTv: msgTv,
        msgMovie: msgMovie,
      );

  RequestState? get searchMovieState;
  RequestState? get searchTvState;
  List<Movie>? get movies;
  List<Tv>? get tvs;

  String? get msgTv;
  String? get msgMovie;
}
