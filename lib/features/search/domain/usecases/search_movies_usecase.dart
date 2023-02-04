import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/repositories/movie_repository.dart';

class SearchMoviesUsecase {
  SearchMoviesUsecase(this.repository);
  final MovieRepository repository;

  Future<DataState<List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
