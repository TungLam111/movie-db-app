import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/media_image.dart';
import '../repositories/movie_repository.dart';

class GetMovieImagesUsecase {
  GetMovieImagesUsecase(this.repository);
  final MovieRepository repository;

  Future<DataState<MediaImage>> execute(int id) {
    return repository.getMovieImages(id);
  }
}
