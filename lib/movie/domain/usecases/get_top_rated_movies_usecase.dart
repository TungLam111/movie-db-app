import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetTopRatedMoviesUsecase {

  GetTopRatedMoviesUsecase(this.repository);
  final MovieRepository repository;

  Future<Either<Failure, List<Movie>>> execute() {
    return repository.getTopRatedMovies();
  }
}
