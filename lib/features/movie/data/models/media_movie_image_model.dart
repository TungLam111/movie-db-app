import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/core/extension/base_model.dart';


part 'media_movie_image_model.g.dart';

@JsonSerializable()
class BackDrop extends AppModel {
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
class Logo extends AppModel {
  Logo({
    required this.filePath,
  });
  factory Logo.fromJson(Map<String, dynamic> json) => _$LogoFromJson(json);

  Map<String, dynamic> toJson() => _$LogoToJson(this);
  @JsonKey(name: 'file_path')
  String? filePath;
}

@JsonSerializable()
class Poster extends AppModel {
  Poster({
    required this.filePath,
  });
  factory Poster.fromJson(Map<String, dynamic> json) => _$PosterFromJson(json);

  Map<String, dynamic> toJson() => _$PosterToJson(this);
  @JsonKey(name: 'file_path')
  String? filePath;
}

@JsonSerializable()
class MediaMovieImageModel extends AppModel {
  MediaMovieImageModel({
    required this.id,
    required this.backdropPaths,
    required this.logoPaths,
    required this.posterPaths,
  });

  factory MediaMovieImageModel.fromJson(Map<String, dynamic> json) =>
      _$MediaMovieImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaMovieImageModelToJson(this);
  final int id;

  @JsonKey(name: 'backdrops')
  final List<BackDrop>? backdropPaths;

  @JsonKey(name: 'logos')
  final List<Logo>? logoPaths;

  @JsonKey(name: 'posters')
  final List<Poster>? posterPaths;

}
