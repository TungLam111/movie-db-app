import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class RemoveWatchlistMovieUsecase {

  RemoveWatchlistMovieUsecase({required this.movieRepository});
  final MovieRepository movieRepository;

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return movieRepository.removeWatchlist(movie);
  }
}
