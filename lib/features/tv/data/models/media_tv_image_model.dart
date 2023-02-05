import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/media_image.dart';

part 'media_tv_image_model.g.dart';

@JsonSerializable()
class BackDrop {
  BackDrop({
    required this.filePath,
  });
  factory BackDrop.fromJson(Map<String, dynamic> json) =>
      _$BackDropFromJson(json);

  Map<String, dynamic> toJson() => _$BackDropToJson(this);

  @JsonKey(name: 'file_path')
  String? filePath;
}

@JsonSerializable()
class Logo {
  Logo({
    required this.filePath,
  });
  factory Logo.fromJson(Map<String, dynamic> json) => _$LogoFromJson(json);

  Map<String, dynamic> toJson() => _$LogoToJson(this);
  @JsonKey(name: 'file_path')
  String? filePath;
}

@JsonSerializable()
class Poster {
  Poster({
    required this.filePath,
  });
  factory Poster.fromJson(Map<String, dynamic> json) => _$PosterFromJson(json);

  Map<String, dynamic> toJson() => _$PosterToJson(this);
  @JsonKey(name: 'file_path')
  String? filePath;
}

@JsonSerializable()
class MediaTvImageModel {
  const MediaTvImageModel({
    required this.id,
    required this.backdropPaths,
    required this.logoPaths,
    required this.posterPaths,
  });

  factory MediaTvImageModel.fromJson(Map<String, dynamic> json) =>
      _$MediaTvImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaTvImageModelToJson(this);

  final int id;

  @JsonKey(name: 'backdrops')
  final List<BackDrop>? backdropPaths;

  @JsonKey(name: 'logos')
  final List<Logo>? logoPaths;

  @JsonKey(name: 'posters')
  final List<Poster>? posterPaths;

  MediaImage toEntity() => MediaImage(
        id: id,
        backdropPaths: backdropPaths,
        logoPaths: logoPaths,
        posterPaths: posterPaths,
      );
}
