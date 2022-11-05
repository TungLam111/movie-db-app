import 'package:equatable/equatable.dart';

import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';

class MovieTable extends Equatable {
  factory MovieTable.fromEntity(MovieDetail movie) => MovieTable(
        releaseDate: movie.releaseDate,
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
      );

  const MovieTable({
    required this.releaseDate,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.voteAverage,
  });

  factory MovieTable.fromMap(Map<String, dynamic> map) => MovieTable(
        releaseDate: map['releaseDate'] as String?,
        id: map['id'] as int,
        title: map['title'] as String?,
        posterPath: map['posterPath'] as String?,
        overview: map['overview'] as String?,
        voteAverage: (map['voteAverage'] as num?)?.toDouble(),
      );
  final String? releaseDate;
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final double? voteAverage;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'releaseDate': releaseDate,
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'voteAverage': voteAverage,
      };

  Movie toEntity() => Movie.watchlist(
        releaseDate: releaseDate,
        id: id,
        overview: overview,
        posterPath: posterPath,
        title: title,
        voteAverage: voteAverage,
      );

  @override
  List<Object?> get props => <Object?>[
        releaseDate,
        id,
        title,
        posterPath,
        overview,
        voteAverage,
      ];
}
