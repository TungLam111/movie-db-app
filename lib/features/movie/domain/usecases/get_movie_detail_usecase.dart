import 'package:mock_bloc_stream/core/base/data_state.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailUsecase {
  GetMovieDetailUsecase(this.repository);
  final MovieRepository repository;

  Future<DataState<MovieDetail>> execute(int id) async {
    return await repository.getMovieDetail(id);
  }
}
