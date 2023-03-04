import 'dart:async';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/search/presentation/bloc/search_state.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import '../../domain/usecases/search_tvs_usecase.dart';

part 'search_event.dart';

class MovieSearchBloc extends BaseBloc {
  MovieSearchBloc(this._searchMoviesUsecase) {
    initActionListen();
  }
  final SearchMoviesUsecase _searchMoviesUsecase;

  final StreamController<SearchEvent> actionController =
      StreamController<SearchEvent>.broadcast();

  SearchState get initialState => _stateSubject.value;
  Stream<SearchState> get stateStream => _stateSubject.stream.distinct();
  final BehaviorSubject<SearchState> _stateSubject =
      BehaviorSubject<SearchState>.seeded(
    SearchState(),
  );
  final PublishSubject<SearchState> lam = PublishSubject<SearchState>();
  final ReplaySubject<SearchState> lam2 = ReplaySubject<SearchState>();

  void initActionListen() {
    actionController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((SearchEvent event) {
      if (event is OnQueryChanged) {
        onSearch(event);
      } else {
        return;
      }
    });
  }

  add(SearchEvent event) {
    actionController.add(event);
  }

  Future<void> onSearch(OnQueryChanged event) async {
    _stateSubject.add(
      _stateSubject.value.rebuild(
        (SearchStateBuilder p0) => p0..searchMovieState = RequestState.loading,
      ),
    );
    final DataState<List<Movie>> result =
        await _searchMoviesUsecase.execute(event.query);

    if (result.isError()) {
      _stateSubject.add(
        _stateSubject.value.rebuild(
          (SearchStateBuilder p0) => p0
            ..msgMovie = result.err
            ..searchMovieState = RequestState.error,
        ),
      );
    } else {
      _stateSubject.add(
        _stateSubject.value.rebuild(
          (SearchStateBuilder p0) => p0
            ..movies = result.data
            ..searchMovieState = RequestState.loaded,
        ),
      );
    }
  }

  @override
  void dispose() {
    _stateSubject.close();
    actionController.close();
    super.dispose();
  }
}

class TvSearchBloc extends BaseBloc {
  TvSearchBloc(this._searchTvsUsecase) {
    initActionListen();
  }
  final StreamController<SearchEvent> actionController =
      StreamController<SearchEvent>.broadcast();

  SearchState get initialState => _stateSubject.value;
  Stream<SearchState> get stateStream => _stateSubject.stream.distinct();
  final BehaviorSubject<SearchState> _stateSubject =
      BehaviorSubject<SearchState>.seeded(
    SearchState(),
  );

  add(SearchEvent event) {
    actionController.add(event);
  }

  void initActionListen() {
    actionController.stream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((SearchEvent event) {
      if (event is OnQueryChanged) {
        onSearch(event);
      } else {
        return;
      }
    });
  }

  Future<void> onSearch(OnQueryChanged event) async {
    _stateSubject.add(
      _stateSubject.value.rebuild(
        (SearchStateBuilder p0) => p0..searchTvState = RequestState.loading,
      ),
    );
    final DataState<List<Tv>> result =
        await _searchTvsUsecase.execute(event.query);

    if (result.isError()) {
      _stateSubject.add(
        _stateSubject.value.rebuild(
          (SearchStateBuilder p0) => p0
            ..searchTvState = RequestState.error
            ..msgTv = result.err,
        ),
      );
    } else {
      _stateSubject.add(
        _stateSubject.value.rebuild(
          (SearchStateBuilder p0) => p0
            ..searchTvState = RequestState.loaded
            ..tvs = result.data,
        ),
      );
    }
  }

  final SearchTvsUsecase _searchTvsUsecase;

  @override
  void dispose() {
    _stateSubject.close();
    actionController.close();
    super.dispose();
  }
}
