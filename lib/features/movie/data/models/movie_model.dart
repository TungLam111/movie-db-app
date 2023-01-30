import 'package:equatable/equatable.dart';

import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';

class MovieModel extends Equatable {
  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        backdropPath: json['backdrop_path'] as String?,
        genreIds: List<int>.from(
          (json['genre_ids'] as List<dynamic>).map((dynamic x) => x as int),
        ),
        id: json['id'] as int,
        overview: json['overview'] as String,
        posterPath: json['poster_path'] as String?,
        releaseDate: json['release_date'] as String,
        title: json['title'] as String,
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'] as int,
      );

  const MovieModel({
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
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final String title;
  final double voteAverage;
  final int voteCount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'backdrop_path': backdropPath,
        'genre_ids': List<dynamic>.from(genreIds.map((int x) => x)),
        'id': id,
        'overview': overview,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'title': title,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  Movie toEntity() => Movie(
        backdropPath: backdropPath,
        genreIds: genreIds,
        id: id,
        overview: overview,
        posterPath: posterPath,
        releaseDate: releaseDate,
        title: title,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

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
