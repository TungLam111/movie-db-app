import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieRecommendationsUsecase {
  GetMovieRecommendationsUsecase(this.repository);
  final MovieRepository repository;

  Future<DataState<List<Movie>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}
