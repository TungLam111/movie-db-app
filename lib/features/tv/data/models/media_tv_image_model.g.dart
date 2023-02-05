// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_tv_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackDrop _$BackDropFromJson(Map<String, dynamic> json) => BackDrop(
      filePath: json['file_path'] as String?,
    );

Map<String, dynamic> _$BackDropToJson(BackDrop instance) => <String, dynamic>{
      'file_path': instance.filePath,
    };

Logo _$LogoFromJson(Map<String, dynamic> json) => Logo(
      filePath: json['file_path'] as String?,
    );

Map<String, dynamic> _$LogoToJson(Logo instance) => <String, dynamic>{
      'file_path': instance.filePath,
    };

Poster _$PosterFromJson(Map<String, dynamic> json) => Poster(
      filePath: json['file_path'] as String?,
    );

Map<String, dynamic> _$PosterToJson(Poster instance) => <String, dynamic>{
      'file_path': instance.filePath,
    };

MediaTvImageModel _$MediaTvImageModelFromJson(Map<String, dynamic> json) =>
    MediaTvImageModel(
      id: json['id'] as int,
      backdropPaths: (json['backdrops'] as List<dynamic>?)
          ?.map((e) => BackDrop.fromJson(e as Map<String, dynamic>))
          .toList(),
      logoPaths: (json['logos'] as List<dynamic>?)
          ?.map((e) => Logo.fromJson(e as Map<String, dynamic>))
          .toList(),
      posterPaths: (json['posters'] as List<dynamic>?)
          ?.map((e) => Poster.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MediaTvImageModelToJson(MediaTvImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'backdrops': instance.backdropPaths,
      'logos': instance.logoPaths,
      'posters': instance.posterPaths,
    };
