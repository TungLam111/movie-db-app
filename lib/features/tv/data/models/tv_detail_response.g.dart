// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvDetailResponse _$TvDetailResponseFromJson(Map<String, dynamic> json) =>
    TvDetailResponse(
      backdropPath: json['backdrop_path'] as String?,
      episodeRunTime: (json['episode_run_time'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      firstAirDate: json['first_air_date'] as String?,
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as int,
      name: json['name'] as String?,
      numberOfSeasons: json['number_of_seasons'] as int?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
    );

Map<String, dynamic> _$TvDetailResponseToJson(TvDetailResponse instance) =>
    <String, dynamic>{
      'backdrop_path': instance.backdropPath,
      'episode_run_time': instance.episodeRunTime,
      'first_air_date': instance.firstAirDate,
      'genres': instance.genres,
      'id': instance.id,
      'name': instance.name,
      'number_of_seasons': instance.numberOfSeasons,
      'overview': instance.overview,
      'poster_path': instance.posterPath,
      'vote_average': instance.voteAverage,
      'vote_count': instance.voteCount,
    };
