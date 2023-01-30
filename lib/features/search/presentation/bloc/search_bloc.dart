import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/search/presentation/bloc/search_state.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
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
    final Either<Failure, List<Movie>> result =
        await _searchMoviesUsecase.execute(event.query);

    result.fold(
      (Failure failure) {
        _stateSubject.add(
          _stateSubject.value.rebuild(
            (SearchStateBuilder p0) => p0
              ..msgMovie = failure.message
              ..searchMovieState = RequestState.error,
          ),
        );
      },
      (List<Movie> data) {
        _stateSubject.add(
          _stateSubject.value.rebuild(
            (SearchStateBuilder p0) => p0
              ..movies = data
              ..searchMovieState = RequestState.loaded,
          ),
        );
      },
    );
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
    final Either<Failure, List<Tv>> result =
        await _searchTvsUsecase.execute(event.query);

    result.fold(
      (Failure failure) {
        _stateSubject.add(
          _stateSubject.value.rebuild(
            (SearchStateBuilder p0) => p0
              ..searchTvState = RequestState.error
              ..msgTv = failure.message,
          ),
        );
      },
      (List<Tv> data) {
        _stateSubject.add(
          _stateSubject.value.rebuild(
            (SearchStateBuilder p0) => p0
              ..searchTvState = RequestState.loaded
              ..tvs = data,
          ),
        );
      },
    );
  }

  final SearchTvsUsecase _searchTvsUsecase;

  @override
  void dispose() {
    _stateSubject.close();
    actionController.close();
    super.dispose();
  }
}
