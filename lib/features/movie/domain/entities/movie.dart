import 'package:mock_bloc_stream/core/extension/base_model.dart';

class Movie extends AppEntity {
  Movie({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  Movie.watchlist({
    required this.releaseDate,
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
    required this.voteAverage,
  });
  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? overview;
  String? posterPath;
  String? releaseDate;
  String? title;
  double? voteAverage;
  int? voteCount;
}
