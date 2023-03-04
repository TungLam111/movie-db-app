import 'package:mock_bloc_stream/utils/common_util.dart';

import 'package:mock_bloc_stream/features/movie/data/models/movie_table.dart';
import 'package:mock_bloc_stream/features/movie/data/datasources/db/movie_database_helper.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);
  Future<String> removeWatchlist(MovieTable movie);
  Future<MovieTable?> getMovieById(int id);
  Future<List<MovieTable>> getWatchlistMovies(int? page);
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  MovieLocalDataSourceImpl({required this.databaseHelper});
  final MovieDatabaseHelper databaseHelper;

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      await databaseHelper.insertMovieWatchlist(movie);
      return 'Added to watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      await databaseHelper.removeMovieWatchlist(movie);
      return 'Removed from watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final Map<String, dynamic>? result = await databaseHelper.getMovieById(id);
    if (result != null) {
      return MovieTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies(int? page) async {
    final List<Map<String, dynamic>> result =
        await databaseHelper.getWatchlistMovies(page);
    return result
        .map((Map<String, dynamic> data) => MovieTable.fromMap(data))
        .toList();
  }
}
