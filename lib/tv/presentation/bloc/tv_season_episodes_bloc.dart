import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv_season_episode.dart';
import '../../domain/usecases/get_tv_season_episodes_usecase.dart';

class TvSeasonEpisodesBloc extends BaseBloc {
  TvSeasonEpisodesBloc({required this.getTvSeasonEpisodes});
  final GetTvSeasonEpisodesUsecase getTvSeasonEpisodes;

  final BehaviorSubject<List<TvSeasonEpisode>> _seasonEpisodes =
      BehaviorSubject<List<TvSeasonEpisode>>.seeded(<TvSeasonEpisode>[]);
  Stream<List<TvSeasonEpisode>> get seasonEpisodes =>
      _seasonEpisodes.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _seasonEpisodesState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get seasonEpisodesStateStream =>
      _seasonEpisodesState.stream.asBroadcastStream();

  Future<void> fetchTvSeasonEpisodes(int id, int seasonNumber) async {
    _seasonEpisodesState.add(RequestState.loading);

    final Either<Failure, List<TvSeasonEpisode>> seasonEpisodesResult =
        await getTvSeasonEpisodes.execute(id, seasonNumber);

    seasonEpisodesResult.fold(
      (Failure failure) {
        _seasonEpisodesState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<TvSeasonEpisode> seasonEpisode) {
        _seasonEpisodesState.add(RequestState.loaded);
        _seasonEpisodes.add(seasonEpisode);
      },
    );
  }

  @override
  void dispose() {
    _seasonEpisodes.close();
    _seasonEpisodesState.close();
    super.dispose();
  }
}
