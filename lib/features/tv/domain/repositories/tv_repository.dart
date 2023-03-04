import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/tv/data/datasources/tv_local_data_source.dart';
import 'package:mock_bloc_stream/features/tv/data/datasources/tv_remote_data_source.dart';
import 'package:mock_bloc_stream/features/tv/data/models/media_tv_image_model.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_detail_response.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_model.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_season_episode_model.dart';
import 'package:mock_bloc_stream/features/tv/data/models/tv_table.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import '../entities/media_image.dart';
import '../entities/tv.dart';
import '../entities/tv_detail.dart';
import '../entities/tv_season_episode.dart';

import 'dart:io';

part '../../data/repositories/tv_repository_impl.dart';

abstract class TvRepository {
  Future<DataState<List<Tv>>> getOnTheAirTvs();
  Future<DataState<List<Tv>>> getPopularTvs(int? page);
  Future<DataState<List<Tv>>> getTopRatedTvs(int? page);
  Future<DataState<TvDetail>> getTvDetail(int id);
  Future<DataState<List<Tv>>> getTvRecommendations(int id);
  Future<DataState<List<TvSeasonEpisode>>> getTvSeasonEpisodes(
    int id,
    int seasonNumber,
  );
  Future<DataState<List<Tv>>> searchTvs(String query);
  Future<DataState<MediaImage>> getTvImages(int id);
  Future<DataState<String>> saveWatchlist(TvDetail tv);
  Future<DataState<String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<DataState<List<Tv>>> getWatchlistTvs();
}
