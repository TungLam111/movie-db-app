import 'package:mock_bloc_stream/core/extension/base_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/media_movie_image_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_detail_response.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/movie_table.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/genre.dart';
import 'package:mock_bloc_stream/features/movie/data/models/genre_model.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/media_image.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie.dart';
import 'package:mock_bloc_stream/features/movie/domain/entities/movie_detail.dart';

class Mapper {
  static dynamic entityToModel<E>(E entity) {
    if (entity is AppEntity) {
    } else {
      return null;
    }
  }

  static E? modelToEntity<M, E>(M model) {
    if (model is AppModel) {
      if (model is GenreModel) {
        return Genre(
          id: model.id,
          name: model.name,
        ) as E;
      }

      if (model is MediaMovieImageModel) {
        return MediaImage(
          id: model.id,
          backdropPaths: model.backdropPaths,
          logoPaths: model.logoPaths,
          posterPaths: model.posterPaths,
        ) as E;
      }

      if (model is MovieDetailResponse) {
        return MovieDetail(
          backdropPath: model.backdropPath,
          genres: (model.genres ?? <GenreModel>[])
              .map(
                (GenreModel genre) =>
                    Mapper.modelToEntity<GenreModel, Genre>(genre)!,
              )
              .toList(),
          id: model.id,
          overview: model.overview,
          posterPath: model.posterPath,
          releaseDate: model.releaseDate,
          runtime: model.runtime,
          title: model.title,
          voteAverage: model.voteAverage,
          voteCount: model.voteCount,
        ) as E;
      }

      if (model is MovieModel) {
        return Movie(
          backdropPath: model.backdropPath,
          genreIds: model.genreIds,
          id: model.id,
          overview: model.overview,
          posterPath: model.posterPath,
          releaseDate: model.releaseDate,
          title: model.title,
          voteAverage: model.voteAverage,
          voteCount: model.voteCount,
        ) as E;
      }

      if (model is MovieTable) {
        return Movie.watchlist(
          releaseDate: model.releaseDate,
          id: model.id,
          overview: model.overview,
          posterPath: model.posterPath,
          title: model.title,
          voteAverage: model.voteAverage,
        ) as E;
      }
      return null;
    } else {
      return null;
    }
  }
}
