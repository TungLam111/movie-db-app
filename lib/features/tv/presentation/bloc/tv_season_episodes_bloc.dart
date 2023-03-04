import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv_season_episode.dart';
import '../../domain/usecases/get_tv_season_episodes_usecase.dart';

class TvSeasonEpisodesBloc extends BaseBloc {
  TvSeasonEpisodesBloc({required this.getTvSeasonEpisodes});
  final GetTvSeasonEpisodesUsecase getTvSeasonEpisodes;

  final BehaviorSubject<List<TvSeasonEpisode>> _seasonEpisodesSubject =
      BehaviorSubject<List<TvSeasonEpisode>>.seeded(<TvSeasonEpisode>[]);
  Stream<List<TvSeasonEpisode>> get seasonEpisodes =>
      _seasonEpisodesSubject.stream;

  final BehaviorSubject<RequestState> _seasonEpisodesStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get seasonEpisodesStateStream =>
      _seasonEpisodesStateSubject.stream;

  Future<void> fetchTvSeasonEpisodes(int id, int seasonNumber) async {
    _seasonEpisodesStateSubject.add(RequestState.loading);

    final DataState<List<TvSeasonEpisode>> seasonEpisodesResult =
        await getTvSeasonEpisodes.execute(id, seasonNumber);

    if (seasonEpisodesResult.isError()) {
      _seasonEpisodesStateSubject.add(RequestState.error);
      messageSubject.add(seasonEpisodesResult.err);
    } else {
      _seasonEpisodesStateSubject.add(RequestState.loaded);
      _seasonEpisodesSubject.add(seasonEpisodesResult.data!);
    }
  }

  @override
  void dispose() {
    _seasonEpisodesSubject.close();
    _seasonEpisodesStateSubject.close();
    super.dispose();
  }
}