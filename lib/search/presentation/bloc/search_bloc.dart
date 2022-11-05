import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mock_bloc_stream/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import '../../domain/usecases/search_tvs_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class MovieSearchBloc extends Bloc<SearchEvent, SearchState> {
  MovieSearchBloc(this._searchMoviesUsecase) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (OnQueryChanged event, Emitter<SearchState> emit) async {
        final String query = event.query;

        emit(SearchLoading());
        final Either<Failure, List<Movie>> result =
            await _searchMoviesUsecase.execute(query);

        result.fold(
          (Failure failure) {
            emit(SearchError(failure.message));
          },
          (List<Movie> data) {
            emit(MovieSearchHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
  final SearchMoviesUsecase _searchMoviesUsecase;
}

class TvSearchBloc extends Bloc<SearchEvent, SearchState> {
  TvSearchBloc(this._searchTvsUsecase) : super(SearchEmpty()) {
    on<OnQueryChanged>(
      (OnQueryChanged event, Emitter<SearchState> emit) async {
        final String query = event.query;

        emit(SearchLoading());
        final Either<Failure, List<Tv>> result =
            await _searchTvsUsecase.execute(query);

        result.fold(
          (Failure failure) {
            emit(SearchError(failure.message));
          },
          (List<Tv> data) {
            emit(TvSearchHasData(data));
          },
        );
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
  final SearchTvsUsecase _searchTvsUsecase;
}
