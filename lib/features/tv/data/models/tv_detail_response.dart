import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_detail.dart';
import 'genre_model.dart';

class TvDetailResponse extends Equatable {
  const TvDetailResponse({
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

  factory TvDetailResponse.fromJson(Map<String, dynamic> json) =>
      TvDetailResponse(
        backdropPath: json['backdrop_path'] as String?,
        episodeRunTime: List<int>.from(
          (json['episode_run_time'] as List<dynamic>).map((dynamic x) => x),
        ),
        firstAirDate: json['first_air_date'] as String,
        genres: List<GenreModel>.from(
          (json['genres'] as List<dynamic>).map(
            (dynamic x) => GenreModel.fromJson(x as Map<String, dynamic>),
          ),
        ),
        id: json['id'] as int,
        name: json['name'] as String,
        numberOfSeasons: json['number_of_seasons'] as int,
        overview: json['overview'] as String,
        posterPath: json['poster_path'] as String?,
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'] as int,
      );
  final String? backdropPath;
  final List<int> episodeRunTime;
  final String firstAirDate;
  final List<GenreModel> genres;
  final int id;
  final String name;
  final int numberOfSeasons;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'backdrop_path': backdropPath,
        'episode_run_time':
            List<dynamic>.from(episodeRunTime.map((int x) => x)),
        'first_air_date': firstAirDate,
        'genres': List<dynamic>.from(genres.map((GenreModel x) => x.toJson())),
        'id': id,
        'name': name,
        'number_of_seasons': numberOfSeasons,
        'overview': overview,
        'poster_path': posterPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  TvDetail toEntity() => TvDetail(
        backdropPath: backdropPath,
        episodeRunTime: episodeRunTime,
        firstAirDate: firstAirDate,
        genres: genres.map((GenreModel genre) => genre.toEntity()).toList(),
        id: id,
        name: name,
        numberOfSeasons: numberOfSeasons,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => <Object?>[
        backdropPath,
        episodeRunTime,
        firstAirDate,
        genres,
        id,
        name,
        numberOfSeasons,
        overview,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
