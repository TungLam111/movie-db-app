import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/tv/data/datasources/tv_local_data_source.dart';
import 'package:mock_bloc_stream/tv/data/datasources/tv_remote_data_source.dart';
import 'package:mock_bloc_stream/tv/data/models/tv_table.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/media_image.dart';
import '../entities/tv.dart';
import '../entities/tv_detail.dart';
import '../entities/tv_season_episode.dart';

import 'dart:io';

import 'package:mock_bloc_stream/tv/data/models/tv_season_episode_model.dart';
import 'package:mock_bloc_stream/tv/data/models/tv_model.dart';
import 'package:mock_bloc_stream/tv/data/models/tv_detail_response.dart';
import 'package:mock_bloc_stream/tv/data/models/media_tv_image_model.dart';

part '../../data/repositories/tv_repository_impl.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnTheAirTvs();
  Future<Either<Failure, List<Tv>>> getPopularTvs();
  Future<Either<Failure, List<Tv>>> getTopRatedTvs();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, List<TvSeasonEpisode>>> getTvSeasonEpisodes(
    int id,
    int seasonNumber,
  );
  Future<Either<Failure, List<Tv>>> searchTvs(String query);
  Future<Either<Failure, MediaImage>> getTvImages(int id);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTvs();
}
