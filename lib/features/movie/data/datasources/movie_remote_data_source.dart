import 'dart:developer';
import 'dart:io';
import 'package:mock_bloc_stream/core/api/api_service.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import 'package:mock_bloc_stream/features/movie/data/models/media_movie_image_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_detail_response.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
  Future<MediaMovieImageModel> getMovieImages(int id);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  MovieRemoteDataSourceImpl({required this.client});
  final ApiService client;

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    try {
      final MovieResponse response = await client.getNowPlayingMovies();
      return response.movieList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final MovieResponse response = await client.getPopularMovies();
      log(response.movieList.length.toString());
      return response.movieList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    try {
      final MovieResponse response = await client.getTopRatedMovies();
      return response.movieList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    try {
      final MovieDetailResponse response = await client.getMovieDetail(id: id);
      return response;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    try {
      final MovieResponse response =
          await client.getMovieRecommendations(id: id);
      return response.movieList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    try {
      final MovieResponse response = await client.searchMovies(query: query);
      return response.movieList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<MediaMovieImageModel> getMovieImages(int id) async {
    try {
      final MediaMovieImageModel response = await client.getMovieImages(id: id);
      return response;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }
}
