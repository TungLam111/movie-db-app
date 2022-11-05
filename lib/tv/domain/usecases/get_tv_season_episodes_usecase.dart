import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';

import '../entities/tv_season_episode.dart';
import '../repositories/tv_repository.dart';

class GetTvSeasonEpisodesUsecase {
  GetTvSeasonEpisodesUsecase(this.repository);
  final TvRepository repository;

  Future<Either<Failure, List<TvSeasonEpisode>>> execute(
    int id,
    int seasonNumber,
  ) {
    return repository.getTvSeasonEpisodes(id, seasonNumber);
  }
}
