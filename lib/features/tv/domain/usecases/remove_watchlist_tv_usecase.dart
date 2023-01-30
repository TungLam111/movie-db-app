import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class RemoveWatchlistTvUsecase {
  RemoveWatchlistTvUsecase({required this.tvRepository});
  final TvRepository tvRepository;

  Future<Either<Failure, String>> execute(TvDetail tv) {
    return tvRepository.removeWatchlist(tv);
  }
}
