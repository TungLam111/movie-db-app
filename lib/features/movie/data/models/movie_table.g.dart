// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieTable _$MovieTableFromJson(Map<String, dynamic> json) => MovieTable(
      releaseDate: json['releaseDate'] as String?,
      id: json['id'] as int,
      title: json['title'] as String?,
      posterPath: json['posterPath'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$MovieTableToJson(MovieTable instance) =>
    <String, dynamic>{
      'releaseDate': instance.releaseDate,
      'id': instance.id,
      'title': instance.title,
      'posterPath': instance.posterPath,
      'overview': instance.overview,
      'voteAverage': instance.voteAverage,
    };
