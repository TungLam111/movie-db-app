import 'package:equatable/equatable.dart';

import 'movie_model.dart';

class MovieResponse extends Equatable {
  const MovieResponse({required this.movieList});

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
  final List<MovieModel> movieList;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'results':
            List<dynamic>.from(movieList.map((MovieModel x) => x.toJson())),
      };

  @override
  List<Object> get props => <Object>[movieList];
}
