// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TvTable _$TvTableFromJson(Map<String, dynamic> json) => TvTable(
      firstAirDate: json['firstAirDate'] as String?,
      id: json['id'] as int,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['posterPath'] as String?,
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TvTableToJson(TvTable instance) => <String, dynamic>{
      'firstAirDate': instance.firstAirDate,
      'id': instance.id,
      'name': instance.name,
      'overview': instance.overview,
      'posterPath': instance.posterPath,
      'voteAverage': instance.voteAverage,
    };
