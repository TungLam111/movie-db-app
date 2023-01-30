import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieRecommendationsUsecase {
  GetMovieRecommendationsUsecase(this.repository);
  final MovieRepository repository;

  Future<Either<Failure, List<Movie>>> execute(int id) {
    return repository.getMovieRecommendations(id);
  }
}
