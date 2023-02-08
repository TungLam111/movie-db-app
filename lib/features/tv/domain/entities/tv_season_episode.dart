import 'package:mock_bloc_stream/core/extension/base_model.dart';

class TvSeasonEpisode extends AppEntity {
  TvSeasonEpisode({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });
  final String? airDate;
  final int? episodeNumber;
  final int id;
  final String? name;
  final String? overview;
  final int? seasonNumber;
  final String? stillPath;
  final double? voteAverage;
  final int? voteCount;
}
