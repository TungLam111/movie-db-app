import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/tv_detail.dart';
import 'genre_model.dart';

part 'tv_detail_response.g.dart';

@JsonSerializable()
class TvDetailResponse {
  const TvDetailResponse({
    required this.backdropPath,
    required this.episodeRunTime,
    required this.firstAirDate,
    required this.genres,
    required this.id,
    required this.name,
    required this.numberOfSeasons,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TvDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TvDetailResponseToJson(this);

  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  @JsonKey(name: 'episode_run_time')
  final List<int>? episodeRunTime;

  @JsonKey(name: 'first_air_date')
  final String? firstAirDate;

  final List<GenreModel>? genres;
  final int id;
  final String? name;

  @JsonKey(name: 'number_of_seasons')
  final int? numberOfSeasons;
  final String? overview;

  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @JsonKey(name: 'vote_average')
  final double? voteAverage;

  @JsonKey(name: 'vote_count')
  final int? voteCount;

  TvDetail toEntity() => TvDetail(
        backdropPath: backdropPath,
        episodeRunTime: episodeRunTime,
        firstAirDate: firstAirDate,
        genres: (genres ?? <GenreModel>[])
            .map((GenreModel genre) => genre.toEntity())
            .toList(),
        id: id,
        name: name,
        numberOfSeasons: numberOfSeasons,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
}
