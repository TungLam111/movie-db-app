import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/repositories/movie_repository.dart';

class GetTopRatedMoviesUsecase {
  GetTopRatedMoviesUsecase(this.repository);
  final MovieRepository repository;

  Future<DataState<List<Movie>>> execute(int? page) {
    return repository.getTopRatedMovies(page);
  }
}
