import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import '../../domain/usecases/search_tvs_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class MovieSearchBloc extends BaseBloc {
  MovieSearchBloc(this._searchMoviesUsecase) {
    initActionListen();
  }
  final SearchMoviesUsecase _searchMoviesUsecase;

  final StreamController<SearchEvent> actionController =
      StreamController<SearchEvent>();

  SearchState get initialState => _stateSubject.value;
  Stream<SearchState> get state =>
      _stateSubject.stream.distinct().asBroadcastStream();
  final BehaviorSubject<SearchState> _stateSubject =
      BehaviorSubject<SearchState>.seeded(
    SearchEmpty(),
  );

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
    _stateSubject.add(SearchLoading());
    final Either<Failure, List<Movie>> result =
        await _searchMoviesUsecase.execute(event.query);

    result.fold(
      (Failure failure) {
        _stateSubject.add(SearchError(failure.message));
      },
      (List<Movie> data) {
        _stateSubject.add(MovieSearchHasData(data));
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
      StreamController<SearchEvent>();

  SearchState get initialState => _stateSubject.value;
  Stream<SearchState> get state =>
      _stateSubject.stream.distinct().asBroadcastStream();
  final BehaviorSubject<SearchState> _stateSubject =
      BehaviorSubject<SearchState>.seeded(
    SearchEmpty(),
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
    _stateSubject.add(SearchLoading());
    final Either<Failure, List<Tv>> result =
        await _searchTvsUsecase.execute(event.query);

    result.fold(
      (Failure failure) {
        _stateSubject.add(SearchError(failure.message));
      },
      (List<Tv> data) {
        _stateSubject.add(TvSearchHasData(data));
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
