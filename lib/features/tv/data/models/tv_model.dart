
import 'package:mock_bloc_stream/core/extension/base_model.dart';

import '../../domain/entities/tv.dart';

class TvModel extends AppModel{
  factory TvModel.fromJson(Map<String, dynamic> json) => TvModel(
        backdropPath: json['backdrop_path'] as String?,
        firstAirDate: json['first_air_date'] as String,
        genreIds: List<int>.from(
          (json['genre_ids'] as List<dynamic>).map((dynamic x) => x),
        ),
        id: json['id'] as int,
        name: json['name'] as String,
        overview: json['overview'] as String,
        posterPath: json['poster_path'] as String?,
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'] as int,
      );

   TvModel({
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
  final String? backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'backdrop_path': backdropPath,
        'first_air_date': firstAirDate,
        'genre_ids': List<dynamic>.from(genreIds.map((int x) => x)),
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  Tv toEntity() => Tv(
        backdropPath: backdropPath,
        firstAirDate: firstAirDate,
        genreIds: genreIds,
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );
}
