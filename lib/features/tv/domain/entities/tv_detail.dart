import 'package:mock_bloc_stream/core/extension/base_model.dart';

import 'package:mock_bloc_stream/features/tv/domain/entities/genre.dart';

class TvDetail extends AppEntity{
   TvDetail({
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
