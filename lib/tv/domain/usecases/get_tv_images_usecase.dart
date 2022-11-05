import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import '../entities/media_image.dart';
import '../repositories/tv_repository.dart';

class GetTvImagesUsecase {
  GetTvImagesUsecase(this.repository);
  final TvRepository repository;

  Future<Either<Failure, MediaImage>> execute(int id) {
    return repository.getTvImages(id);
  }
}
