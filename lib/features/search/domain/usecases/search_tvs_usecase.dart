import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/features/tv/domain/repositories/tv_repository.dart';

class SearchTvsUsecase {
  SearchTvsUsecase(this.repository);
  final TvRepository repository;

  Future<DataState<List<Tv>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
