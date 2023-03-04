// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SearchState extends SearchState {
  @override
  final RequestState? searchMovieState;
  @override
  final RequestState? searchTvState;
  @override
  final List<Movie>? movies;
  @override
  final List<Tv>? tvs;
  @override
  final String? msgTv;
  @override
  final String? msgMovie;

  factory _$SearchState([void Function(SearchStateBuilder)? updates]) =>
      (new SearchStateBuilder()..update(updates))._build();

  _$SearchState._(
      {this.searchMovieState,
      this.searchTvState,
      this.movies,
      this.tvs,
      this.msgTv,
      this.msgMovie})
      : super._();

  @override
  SearchState rebuild(void Function(SearchStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SearchStateBuilder toBuilder() => new SearchStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SearchState &&
        searchMovieState == other.searchMovieState &&
        searchTvState == other.searchTvState &&
        movies == other.movies &&
        tvs == other.tvs &&
        msgTv == other.msgTv &&
        msgMovie == other.msgMovie;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, searchMovieState.hashCode);
    _$hash = $jc(_$hash, searchTvState.hashCode);
    _$hash = $jc(_$hash, movies.hashCode);
    _$hash = $jc(_$hash, tvs.hashCode);
    _$hash = $jc(_$hash, msgTv.hashCode);
    _$hash = $jc(_$hash, msgMovie.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SearchState')
          ..add('searchMovieState', searchMovieState)
          ..add('searchTvState', searchTvState)
          ..add('movies', movies)
          ..add('tvs', tvs)
          ..add('msgTv', msgTv)
          ..add('msgMovie', msgMovie))
        .toString();
  }
}

class SearchStateBuilder implements Builder<SearchState, SearchStateBuilder> {
  _$SearchState? _$v;

  RequestState? _searchMovieState;
  RequestState? get searchMovieState => _$this._searchMovieState;
  set searchMovieState(RequestState? searchMovieState) =>
      _$this._searchMovieState = searchMovieState;

  RequestState? _searchTvState;
  RequestState? get searchTvState => _$this._searchTvState;
  set searchTvState(RequestState? searchTvState) =>
      _$this._searchTvState = searchTvState;

  List<Movie>? _movies;
  List<Movie>? get movies => _$this._movies;
  set movies(List<Movie>? movies) => _$this._movies = movies;

  List<Tv>? _tvs;
  List<Tv>? get tvs => _$this._tvs;
  set tvs(List<Tv>? tvs) => _$this._tvs = tvs;

  String? _msgTv;
  String? get msgTv => _$this._msgTv;
  set msgTv(String? msgTv) => _$this._msgTv = msgTv;

  String? _msgMovie;
  String? get msgMovie => _$this._msgMovie;
  set msgMovie(String? msgMovie) => _$this._msgMovie = msgMovie;

  SearchStateBuilder();

  SearchStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _searchMovieState = $v.searchMovieState;
      _searchTvState = $v.searchTvState;
      _movies = $v.movies;
      _tvs = $v.tvs;
      _msgTv = $v.msgTv;
      _msgMovie = $v.msgMovie;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SearchState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SearchState;
  }

  @override
  void update(void Function(SearchStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SearchState build() => _build();

  _$SearchState _build() {
    final _$result = _$v ??
        new _$SearchState._(
            searchMovieState: searchMovieState,
            searchTvState: searchTvState,
            movies: movies,
            tvs: tvs,
            msgTv: msgTv,
            msgMovie: msgMovie);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
