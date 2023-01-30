import '../repositories/movie_repository.dart';

class GetMovieWatchlistStatusUsecase {
  GetMovieWatchlistStatusUsecase({
    required this.movieRepository,
  });
  final MovieRepository movieRepository;

  Future<bool> execute(int id) async {
    return movieRepository.isAddedToWatchlist(id);
  }
}
