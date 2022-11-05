import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/movie/data/models/movie_model.dart';
import 'package:mock_bloc_stream/movie/data/models/movie_detail_response.dart';
import 'package:mock_bloc_stream/movie/data/models/media_movie_image_model.dart';
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
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final List<MovieModel> result =
          await remoteDataSource.getNowPlayingMovies();
      return Right<Failure, List<Movie>>(
        result.map((MovieModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Movie>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Movie>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final List<MovieModel> result = await remoteDataSource.getPopularMovies();
      return Right<Failure, List<Movie>>(
        result.map((MovieModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Movie>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Movie>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    try {
      final List<MovieModel> result =
          await remoteDataSource.getTopRatedMovies();
      return Right<Failure, List<Movie>>(
        result.map((MovieModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Movie>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Movie>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) async {
    try {
      final MovieDetailResponse result =
          await remoteDataSource.getMovieDetail(id);
      return Right<Failure, MovieDetail>(result.toEntity());
    } on ServerException {
      return const Left<Failure, MovieDetail>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, MovieDetail>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) async {
    try {
      final List<MovieModel> result =
          await remoteDataSource.getMovieRecommendations(id);
      return Right<Failure, List<Movie>>(
        result.map((MovieModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Movie>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Movie>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final List<MovieModel> result =
          await remoteDataSource.searchMovies(query);
      return Right<Failure, List<Movie>>(
        result.map((MovieModel model) => model.toEntity()).toList(),
      );
    } on ServerException {
      return const Left<Failure, List<Movie>>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, List<Movie>>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, MediaImage>> getMovieImages(int id) async {
    try {
      final MediaMovieImageModel result =
          await remoteDataSource.getMovieImages(id);
      return Right<Failure, MediaImage>(result.toEntity());
    } on ServerException {
      return const Left<Failure, MediaImage>(ServerFailure(''));
    } on SocketException {
      return const Left<Failure, MediaImage>(
        ConnectionFailure('Failed to connect to the network'),
      );
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async {
    try {
      final String result =
          await localDataSource.insertWatchlist(MovieTable.fromEntity(movie));
      return Right<Failure, String>(result);
    } on DatabaseException catch (e) {
      return Left<Failure, String>(DatabaseFailure(e.message));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async {
    try {
      final String result =
          await localDataSource.removeWatchlist(MovieTable.fromEntity(movie));
      return Right<Failure, String>(result);
    } on DatabaseException catch (e) {
      return Left<Failure, String>(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final MovieTable? result = await localDataSource.getMovieById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() async {
    final List<MovieTable> result = await localDataSource.getWatchlistMovies();
    return Right<Failure, List<Movie>>(
      result.map((MovieTable data) => data.toEntity()).toList(),
    );
  }
}
