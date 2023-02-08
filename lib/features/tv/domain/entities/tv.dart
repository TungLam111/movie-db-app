import 'package:mock_bloc_stream/core/extension/base_model.dart';

class Tv extends AppEntity {
  Tv({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  Tv.watchList({
    required this.firstAirDate,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });
  String? backdropPath;
  String? firstAirDate;
  List<int>? genreIds;
  int id;
  String? name;
  String? overview;
  String? posterPath;
  double? voteAverage;
  int? voteCount;
}
