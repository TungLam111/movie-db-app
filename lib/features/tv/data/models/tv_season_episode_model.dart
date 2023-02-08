import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/core/extension/base_model.dart';

import '../../domain/entities/tv_season_episode.dart';

part 'tv_season_episode_model.g.dart';

@JsonSerializable()
class TvSeasonEpisodeModel extends AppModel {
  TvSeasonEpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });
  factory TvSeasonEpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$TvSeasonEpisodeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TvSeasonEpisodeModelToJson(this);

  @JsonKey(name: 'air_date')
  final String? airDate;

  @JsonKey(name: 'episode_number')
  final int? episodeNumber;

  final int id;
  final String? name;
  final String? overview;

  @JsonKey(name: 'season_number')
  final int? seasonNumber;

  @JsonKey(name: 'still_path')
  final String? stillPath;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  @JsonKey(name: 'vote_count')
  final int? voteCount;

  TvSeasonEpisode toEntity() => TvSeasonEpisode(
        airDate: airDate,
        episodeNumber: episodeNumber,
        id: id,
        name: name,
        overview: overview,
        seasonNumber: seasonNumber,
        stillPath: stillPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
}
