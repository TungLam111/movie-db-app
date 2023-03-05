import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/core/extension/base_model.dart';

part 'genre_model.g.dart';

@JsonSerializable()
class GenreModel extends AppModel {
  GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;
}
