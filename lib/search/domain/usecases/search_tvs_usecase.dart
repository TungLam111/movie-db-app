import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/tv/domain/entities/tv.dart';
import 'package:mock_bloc_stream/tv/domain/repositories/tv_repository.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

class SearchTvsUsecase {

  SearchTvsUsecase(this.repository);
  final TvRepository repository;

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
