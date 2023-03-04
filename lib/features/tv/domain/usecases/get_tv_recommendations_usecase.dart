import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/tv.dart';
import '../repositories/tv_repository.dart';

class GetTvRecommendationsUsecase {
  GetTvRecommendationsUsecase(this.repository);
  final TvRepository repository;

  Future<DataState<List<Tv>>> execute(int id) {
    return repository.getTvRecommendations(id);
  }
}
