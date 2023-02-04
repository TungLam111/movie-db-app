import 'package:mock_bloc_stream/core/base/data_state.dart';

import '../entities/media_image.dart';
import '../repositories/tv_repository.dart';

class GetTvImagesUsecase {
  GetTvImagesUsecase(this.repository);
  final TvRepository repository;

  Future<DataState<MediaImage>> execute(int id) {
    return repository.getTvImages(id);
  }
}
