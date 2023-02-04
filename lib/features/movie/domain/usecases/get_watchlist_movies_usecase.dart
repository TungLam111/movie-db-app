import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetWatchlistMoviesUsecase {
  GetWatchlistMoviesUsecase(this._repository);
  final MovieRepository _repository;

  Future<DataState<List<Movie>>> execute(int? page) {
    return _repository.getWatchlistMovies(page);
  }
}
