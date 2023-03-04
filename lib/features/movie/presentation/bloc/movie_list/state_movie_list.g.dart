// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_movie_list.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MovieListState extends MovieListState {
  @override
  final RequestState? nowPlayingMoviesState;
  @override
  final RequestState? popularMoviesState;
  @override
  final RequestState? topRatedMoviesState;
  @override
  final List<Movie>? nowPlayingMovies;
  @override
  final List<Movie>? popularMovies;
  @override
  final List<Movie>? topRatedMovies;

  factory _$MovieListState([void Function(MovieListStateBuilder)? updates]) =>
      (new MovieListStateBuilder()..update(updates))._build();

  _$MovieListState._(
      {this.nowPlayingMoviesState,
      this.popularMoviesState,
      this.topRatedMoviesState,
      this.nowPlayingMovies,
      this.popularMovies,
      this.topRatedMovies})
      : super._();

  @override
  MovieListState rebuild(void Function(MovieListStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MovieListStateBuilder toBuilder() =>
      new MovieListStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MovieListState &&
        nowPlayingMoviesState == other.nowPlayingMoviesState &&
        popularMoviesState == other.popularMoviesState &&
        topRatedMoviesState == other.topRatedMoviesState &&
        nowPlayingMovies == other.nowPlayingMovies &&
        popularMovies == other.popularMovies &&
        topRatedMovies == other.topRatedMovies;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nowPlayingMoviesState.hashCode);
    _$hash = $jc(_$hash, popularMoviesState.hashCode);
    _$hash = $jc(_$hash, topRatedMoviesState.hashCode);
    _$hash = $jc(_$hash, nowPlayingMovies.hashCode);
    _$hash = $jc(_$hash, popularMovies.hashCode);
    _$hash = $jc(_$hash, topRatedMovies.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MovieListState')
          ..add('nowPlayingMoviesState', nowPlayingMoviesState)
          ..add('popularMoviesState', popularMoviesState)
          ..add('topRatedMoviesState', topRatedMoviesState)
          ..add('nowPlayingMovies', nowPlayingMovies)
          ..add('popularMovies', popularMovies)
          ..add('topRatedMovies', topRatedMovies))
        .toString();
  }
}

class MovieListStateBuilder
    implements Builder<MovieListState, MovieListStateBuilder> {
  _$MovieListState? _$v;

  RequestState? _nowPlayingMoviesState;
  RequestState? get nowPlayingMoviesState => _$this._nowPlayingMoviesState;
  set nowPlayingMoviesState(RequestState? nowPlayingMoviesState) =>
      _$this._nowPlayingMoviesState = nowPlayingMoviesState;

  RequestState? _popularMoviesState;
  RequestState? get popularMoviesState => _$this._popularMoviesState;
  set popularMoviesState(RequestState? popularMoviesState) =>
      _$this._popularMoviesState = popularMoviesState;

  RequestState? _topRatedMoviesState;
  RequestState? get topRatedMoviesState => _$this._topRatedMoviesState;
  set topRatedMoviesState(RequestState? topRatedMoviesState) =>
      _$this._topRatedMoviesState = topRatedMoviesState;

  List<Movie>? _nowPlayingMovies;
  List<Movie>? get nowPlayingMovies => _$this._nowPlayingMovies;
  set nowPlayingMovies(List<Movie>? nowPlayingMovies) =>
      _$this._nowPlayingMovies = nowPlayingMovies;

  List<Movie>? _popularMovies;
  List<Movie>? get popularMovies => _$this._popularMovies;
  set popularMovies(List<Movie>? popularMovies) =>
      _$this._popularMovies = popularMovies;

  List<Movie>? _topRatedMovies;
  List<Movie>? get topRatedMovies => _$this._topRatedMovies;
  set topRatedMovies(List<Movie>? topRatedMovies) =>
      _$this._topRatedMovies = topRatedMovies;

  MovieListStateBuilder();

  MovieListStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nowPlayingMoviesState = $v.nowPlayingMoviesState;
      _popularMoviesState = $v.popularMoviesState;
      _topRatedMoviesState = $v.topRatedMoviesState;
      _nowPlayingMovies = $v.nowPlayingMovies;
      _popularMovies = $v.popularMovies;
      _topRatedMovies = $v.topRatedMovies;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MovieListState other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$MovieListState;
  }

  @override
  void update(void Function(MovieListStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MovieListState build() => _build();

  _$MovieListState _build() {
    final _$result = _$v ??
        new _$MovieListState._(
            nowPlayingMoviesState: nowPlayingMoviesState,
            popularMoviesState: popularMoviesState,
            topRatedMoviesState: topRatedMoviesState,
            nowPlayingMovies: nowPlayingMovies,
            popularMovies: popularMovies,
            topRatedMovies: topRatedMovies);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
