import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetWatchlistTvsUsecase {

  GetWatchlistTvsUsecase(this.repository);
  final TvRepository repository;

  Future<Either<Failure, List<Tv>>> execute(int? page) {
    return repository.getWatchlistTvs();
  }
}
