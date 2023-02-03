import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:dartz/dartz.dart';

import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetTopRatedTvsUsecase {
  GetTopRatedTvsUsecase(this.repository);
  final TvRepository repository;

  Future<Either<Failure, List<Tv>>> execute(int? page) {
    return repository.getTopRatedTvs(page);
  }
}
