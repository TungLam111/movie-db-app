import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/genre.dart';

part 'genre_model.g.dart';


@JsonSerializable()
class GenreModel {
  const GenreModel({
    required this.id,
    required this.name,
  });
  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);

  final int id;
  final String? name;

  Genre toEntity() => Genre(
        id: id,
        name: name,
      );
}
