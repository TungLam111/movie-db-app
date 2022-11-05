import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_detail.dart';
import 'genre_model.dart';

class MovieDetailResponse extends Equatable {
  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) =>
      MovieDetailResponse(
        backdropPath: json['backdrop_path'] as String?,
        genres: List<GenreModel>.from(
          (json['genres'] as List<dynamic>).map(
            (dynamic x) => GenreModel.fromJson(x as Map<String, dynamic>),
          ),
        ),
        id: json['id'] as int,
        overview: json['overview'] as String,
        posterPath: json['poster_path'] as String?,
        releaseDate: json['release_date'] as String,
        runtime: json['runtime'] as int,
        title: json['title'] as String,
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'] as int,
      );

  const MovieDetailResponse({
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
  final List<GenreModel> genres;
  final int id;
  final String overview;
  final String? posterPath;
  final String releaseDate;
  final int runtime;
  final String title;
  final double voteAverage;
  final int voteCount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'backdrop_path': backdropPath,
        'genres': List<dynamic>.from(genres.map((dynamic x) => x.toJson())),
        'id': id,
        'overview': overview,
        'poster_path': posterPath,
        'release_date': releaseDate,
        'runtime': runtime,
        'title': title,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  MovieDetail toEntity() => MovieDetail(
        backdropPath: backdropPath,
        genres: genres.map((GenreModel genre) => genre.toEntity()).toList(),
        id: id,
        overview: overview,
        posterPath: posterPath,
        releaseDate: releaseDate,
        runtime: runtime,
        title: title,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => <Object?>[
        backdropPath,
        genres,
        id,
        overview,
        posterPath,
        releaseDate,
        runtime,
        title,
        voteAverage,
        voteCount,
      ];
}
