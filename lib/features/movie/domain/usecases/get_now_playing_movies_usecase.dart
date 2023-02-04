import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetNowPlayingMoviesUsecase {
  GetNowPlayingMoviesUsecase(this.repository);
  final MovieRepository repository;

  Future<DataState<List<Movie>>> execute() {
    return repository.getNowPlayingMovies();
  }
}
