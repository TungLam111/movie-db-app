import 'package:mock_bloc_stream/core/extension/base_model.dart';

import 'movie_model.dart';

class MovieResponse  extends AppModel{
   MovieResponse({required this.movieList});

  factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
        movieList: List<MovieModel>.from(
          (json['results'] as List<dynamic>)
              .map(
                (dynamic x) => MovieModel.fromJson(x as Map<String, dynamic>),
              )
              .where(
                (MovieModel element) =>
                    element.posterPath != null && element.backdropPath != null,
              ),
        ),
      );

  final List<MovieModel>? movieList;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'results': List<dynamic>.from(
          (movieList ?? <MovieModel>[]).map((MovieModel x) => x.toJson()),
        ),
      };
}