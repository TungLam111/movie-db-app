import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/core/extension/base_model.dart';

import 'genre_model.dart';
part 'movie_detail_response.g.dart';

@JsonSerializable()
class MovieDetailResponse extends AppModel {
  MovieDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.runtime,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieDetailResponseToJson(this);

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  final List<GenreModel>? genres;
  final int id;
  final String? overview;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'release_date')
  final String? releaseDate;

  final int? runtime;
  final String? title;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  @JsonKey(name: 'vote_count')
  final int? voteCount;

}
