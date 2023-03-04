import 'dart:io';

import 'package:mock_bloc_stream/core/api/api_service.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import 'package:mock_bloc_stream/features/tv/data/models/media_tv_image_model.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_detail_response.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_model.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_response.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_season_episode_model.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_season_episode_response.dart';

abstract class TvRemoteDataSource {
  Future<List<TvModel>?> getOnTheAirTvs();
  Future<List<TvModel>?> getPopularTvs(int? page);
  Future<List<TvModel>?> getTopRatedTvs(int? page);
  Future<TvDetailResponse> getTvDetail(int id);
  Future<List<TvSeasonEpisodeModel>?> getTvSeasonEpisodes(
    int id,
    int seasonNumber,
  );
  Future<List<TvModel>?> getTvRecommendations(int id);
  Future<List<TvModel>?> searchTvs(String query);
  Future<MediaTvImageModel> getTvImages(int id);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  TvRemoteDataSourceImpl({required this.client});
  final ApiService client;

  @override
  Future<List<TvModel>?> getOnTheAirTvs() async {
    try {
      final TvResponse response = await client.getOnTheAirTvs();
      return response.tvList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<TvModel>?> getPopularTvs(int? page) async {
    try {
      final TvResponse response = await client.getPopularTvs(page: page ?? 1);
      return response.tvList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<TvModel>?> getTopRatedTvs(int? page) async {
    try {
      final TvResponse response = await client.getTopRatedTvs(page: page ?? 1);
      return response.tvList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    try {
      final TvDetailResponse response = await client.getTvDetail(id: id);
      return response;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<TvSeasonEpisodeModel>?> getTvSeasonEpisodes(
    int id,
    int seasonNumber,
  ) async {
    try {
      final TvSeasonEpisodeResponse response = await client.getTvSeasonEpisodes(
        id: id,
        seasonNumber: seasonNumber,
      );
      return response.tvEpisodes;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<TvModel>?> getTvRecommendations(int id) async {
    try {
      final TvResponse response = await client.getTvRecommendations(id: id);
      return response.tvList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<List<TvModel>?> searchTvs(String query) async {
    try {
      final TvResponse response = await client.searchTvs(query: query);
      return response.tvList;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }

  @override
  Future<MediaTvImageModel> getTvImages(int id) async {
    try {
      final MediaTvImageModel response = await client.getTvImages(id: id);
      return response;
    } on ServerException {
      throw ServerException();
    } on SocketException {
      throw const SocketException('Socket exception');
    }
  }
}
