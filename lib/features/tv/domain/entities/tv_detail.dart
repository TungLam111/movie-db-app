import 'genre.dart';

class TvDetail {
  const TvDetail({
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
  final String? backdropPath;
  final List<int>? episodeRunTime;
  final String? firstAirDate;
  final List<Genre>? genres;
  final int id;
  final String? name;
  final int? numberOfSeasons;
  final String? overview;
  final String? posterPath;
  final double? voteAverage;
  final int? voteCount;
}
