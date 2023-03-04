import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class SaveWatchlistMovieUsecase {
  SaveWatchlistMovieUsecase({required this.movieRepository});
  final MovieRepository movieRepository;

  Future<DataState<String>> execute(MovieDetail movie) {
    return movieRepository.saveWatchlist(movie);
  }
}
