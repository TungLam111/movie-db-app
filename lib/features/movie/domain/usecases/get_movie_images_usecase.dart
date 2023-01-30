import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/media_image.dart';
import '../repositories/movie_repository.dart';

class GetMovieImagesUsecase {
  GetMovieImagesUsecase(this.repository);
  final MovieRepository repository;

  Future<Either<Failure, MediaImage>> execute(int id) {
    return repository.getMovieImages(id);
  }
}
