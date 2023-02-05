import 'package:mock_bloc_stream/features/movie/domain/entities/genre.dart';

class MovieDetail {
  const MovieDetail({
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
  final String? backdropPath;
  final List<Genre>? genres;
  final int id;
  final String? overview;
  final String? posterPath;
  final String? releaseDate;
  final int? runtime;
  final String? title;
  final double? voteAverage;
  final int? voteCount;
}
