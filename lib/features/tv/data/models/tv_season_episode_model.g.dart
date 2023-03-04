// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_season_episode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvSeasonEpisodeModel _$TvSeasonEpisodeModelFromJson(
        Map<String, dynamic> json) =>
    TvSeasonEpisodeModel(
      airDate: json['air_date'] as String?,
      episodeNumber: json['episode_number'] as int?,
      id: json['id'] as int,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      seasonNumber: json['season_number'] as int?,
      stillPath: json['still_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
    );

Map<String, dynamic> _$TvSeasonEpisodeModelToJson(
        TvSeasonEpisodeModel instance) =>
    <String, dynamic>{
      'air_date': instance.airDate,
      'episode_number': instance.episodeNumber,
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'season_number': instance.seasonNumber,
      'still_path': instance.stillPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
