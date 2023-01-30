import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Movie extends Equatable {
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

  @override
  List<Object?> get props => <Object?>[
        backdropPath,
        genreIds,
        id,
        overview,
        posterPath,
        releaseDate,
        title,
        voteAverage,
        voteCount,
      ];
}
