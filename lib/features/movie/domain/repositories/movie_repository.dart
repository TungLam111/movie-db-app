import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/media_image.dart';
import '../entities/movie.dart';
import '../entities/movie_detail.dart';

abstract class MovieRepository {
  Future<DataState<List<Movie>>> getNowPlayingMovies();
  Future<DataState<List<Movie>>> getPopularMovies(int? page);
  Future<DataState<List<Movie>>> getTopRatedMovies(int? page);
  Future<DataState<MovieDetail>> getMovieDetail(int id);
  Future<DataState<List<Movie>>> getMovieRecommendations(int id);
  Future<DataState<List<Movie>>> searchMovies(String query);
  Future<DataState<MediaImage>> getMovieImages(int id);
  Future<DataState<String>> saveWatchlist(MovieDetail movie);
  Future<DataState<String>> removeWatchlist(MovieDetail movie);
  Future<bool> isAddedToWatchlist(int id);
  Future<DataState<List<Movie>>> getWatchlistMovies(int? page);
}
