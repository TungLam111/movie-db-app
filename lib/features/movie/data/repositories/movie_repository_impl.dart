import 'dart:io';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/core/extension/mapper.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_detail_response.dart';
import 'package:mock_bloc_stream/features/movie/data/models/media_movie_image_model.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import '../../domain/entities/media_image.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_local_data_source.dart';
import '../datasources/movie_remote_data_source.dart';
import '../models/movie_table.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;

  @override
  Future<DataState<List<Movie>>> getNowPlayingMovies() async {
    try {
      final List<MovieModel> result =
          (await remoteDataSource.getNowPlayingMovies()) ?? <MovieModel>[];
      return DataSuccess<List<Movie>>(
        result
            .map(
              (MovieModel model) =>
                  Mapper.modelToEntity<MovieModel, Movie>(model)!,
            )
            .toList(),
      );
    } on ServerException {
      return DataFailed<List<Movie>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Movie>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Movie>>> getPopularMovies(int? page) async {
    try {
      final List<MovieModel>? result =
          await remoteDataSource.getPopularMovies(page);
      return DataSuccess<List<Movie>>(
        (result ?? <MovieModel>[])
            .map(
              (MovieModel model) =>
                  Mapper.modelToEntity<MovieModel, Movie>(model)!,
            )
            .toList(),
      );
    } on ServerException {
      return DataFailed<List<Movie>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Movie>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Movie>>> getTopRatedMovies(int? page) async {
    try {
      final List<MovieModel>? result =
          await remoteDataSource.getTopRatedMovies(page);
      return DataSuccess<List<Movie>>(
        (result ?? <MovieModel>[])
            .map(
              (MovieModel model) =>
                  Mapper.modelToEntity<MovieModel, Movie>(model)!,
            )
            .toList(),
      );
    } on ServerException {
      return DataFailed<List<Movie>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Movie>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<MovieDetail>> getMovieDetail(int id) async {
    try {
      final MovieDetailResponse result =
          await remoteDataSource.getMovieDetail(id);
      return DataSuccess<MovieDetail>(
        Mapper.modelToEntity<MovieDetailResponse, MovieDetail>(result)!,
      );
    } on ServerException {
      return DataFailed<MovieDetail>(ServerException());
    } on SocketException {
      return const DataFailed<MovieDetail>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Movie>>> getMovieRecommendations(int id) async {
    try {
      final List<MovieModel>? result =
          await remoteDataSource.getMovieRecommendations(id);
      return DataSuccess<List<Movie>>(
        (result ?? <MovieModel>[])
            .map(
              (MovieModel model) =>
                  Mapper.modelToEntity<MovieModel, Movie>(model)!,
            )
            .toList(),
      );
    } on ServerException {
      return DataFailed<List<Movie>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Movie>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<List<Movie>>> searchMovies(String query) async {
    try {
      final List<MovieModel>? result =
          await remoteDataSource.searchMovies(query);
      return DataSuccess<List<Movie>>(
        (result ?? <MovieModel>[])
            .map(
              (MovieModel model) =>
                  Mapper.modelToEntity<MovieModel, Movie>(model)!,
            )
            .toList(),
      );
    } on ServerException {
      return DataFailed<List<Movie>>(ServerException());
    } on SocketException {
      return const DataFailed<List<Movie>>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<MediaImage>> getMovieImages(int id) async {
    try {
      final MediaMovieImageModel result =
          await remoteDataSource.getMovieImages(id);
      return DataSuccess<MediaImage>(
        Mapper.modelToEntity<MediaMovieImageModel, MediaImage>(result)!,
      );
    } on ServerException {
      return DataFailed<MediaImage>(ServerException());
    } on SocketException {
      return const DataFailed<MediaImage>(
        SocketException('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<DataState<String>> saveWatchlist(MovieDetail movie) async {
    try {
      final String result =
          await localDataSource.insertWatchlist(MovieTable.fromEntity(movie));
      return DataSuccess<String>(result);
    } on DatabaseException catch (e) {
      return DataFailed<String>(DatabaseException(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DataState<String>> removeWatchlist(MovieDetail movie) async {
    try {
      final String result =
          await localDataSource.removeWatchlist(MovieTable.fromEntity(movie));
      return DataSuccess<String>(result);
    } on DatabaseException catch (e) {
      return DataFailed<String>(DatabaseException(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final MovieTable? result = await localDataSource.getMovieById(id);
    return result != null;
  }

  @override
  Future<DataState<List<Movie>>> getWatchlistMovies(int? page) async {
    final List<MovieTable> result =
        await localDataSource.getWatchlistMovies(page);
    return DataSuccess<List<Movie>>(
      result
          .map(
            (MovieTable data) => Mapper.modelToEntity<MovieTable, Movie>(data)!,
          )
          .toList(),
    );
  }
}
