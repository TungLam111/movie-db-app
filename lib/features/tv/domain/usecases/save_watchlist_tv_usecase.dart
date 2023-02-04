import 'package:mock_bloc_stream/core/base/data_state.dart';

import '../entities/tv_detail.dart';
import '../repositories/tv_repository.dart';

class SaveWatchlistTvUsecase {
  SaveWatchlistTvUsecase({required this.tvRepository});
  final TvRepository tvRepository;

  Future<DataState<String>> execute(TvDetail tv) {
    return tvRepository.saveWatchlist(tv);
  }
}
