import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/repositories/movie_repository.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

class SearchMoviesUsecase {

  SearchMoviesUsecase(this.repository);
  final MovieRepository repository;

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
