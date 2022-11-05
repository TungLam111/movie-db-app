import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class GetTvDetailUsecase {
  GetTvDetailUsecase(this.repository);
  final TvRepository repository;

  Future<Either<Failure, TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
