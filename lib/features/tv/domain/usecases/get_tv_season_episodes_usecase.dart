import 'package:mock_bloc_stream/core/base/data_state.dart';

import '../entities/tv_season_episode.dart';
import '../repositories/tv_repository.dart';

class GetTvSeasonEpisodesUsecase {
  GetTvSeasonEpisodesUsecase(this.repository);
  final TvRepository repository;

  Future<DataState<List<TvSeasonEpisode>>> execute(
    int id,
    int seasonNumber,
  ) {
    return repository.getTvSeasonEpisodes(id, seasonNumber);
  }
}
