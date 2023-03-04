import 'package:mock_bloc_stream/core/extension/base_model.dart';
import 'package:mock_bloc_stream/features/movie/data/models/media_movie_image_model.dart';

class MediaImage extends AppEntity{
   MediaImage({
    required this.id,
    required this.backdropPaths,
    required this.logoPaths,
    required this.posterPaths,
  });
  final int id;
  final List<BackDrop>? backdropPaths;
  final List<Logo>? logoPaths;
  final List<Poster>? posterPaths;
}
