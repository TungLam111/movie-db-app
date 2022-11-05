part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => <Object?>[];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  const SearchError(this.message);
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

class MovieSearchHasData extends SearchState {
  const MovieSearchHasData(this.result);
  final List<Movie> result;

  @override
  List<Object?> get props => <Object?>[result];
}

class TvSearchHasData extends SearchState {
  const TvSearchHasData(this.result);
  final List<Tv> result;

  @override
  List<Object?> get props => <Object?>[result];
}
