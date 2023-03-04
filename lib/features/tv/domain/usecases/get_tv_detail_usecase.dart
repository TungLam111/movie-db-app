import 'package:mock_bloc_stream/core/base/data_state.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class GetTvDetailUsecase {
  GetTvDetailUsecase(this.repository);
  final TvRepository repository;

  Future<DataState<TvDetail>> execute(int id) {
    return repository.getTvDetail(id);
  }
}
