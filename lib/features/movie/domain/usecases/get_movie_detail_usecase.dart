import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailUsecase {

  GetMovieDetailUsecase(this.repository);
  final MovieRepository repository;

  Future<Either<Failure, MovieDetail>> execute(int id) {
    return repository.getMovieDetail(id);
  }
}
