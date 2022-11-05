import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/tv_season_episode.dart';
import '../../domain/usecases/get_tv_season_episodes_usecase.dart';

class TvSeasonEpisodesNotifier extends ChangeNotifier {

  TvSeasonEpisodesNotifier({required this.getTvSeasonEpisodes});
  final GetTvSeasonEpisodesUsecase getTvSeasonEpisodes;

  late List<TvSeasonEpisode> _seasonEpisodes;
  List<TvSeasonEpisode> get seasonEpisodes => _seasonEpisodes;

  RequestState _seasonEpisodesState = RequestState.empty;
  RequestState get seasonEpisodesState => _seasonEpisodesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvSeasonEpisodes(int id, int seasonNumber) async {
    _seasonEpisodesState = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<TvSeasonEpisode>> seasonEpisodesResult =
        await getTvSeasonEpisodes.execute(id, seasonNumber);

    seasonEpisodesResult.fold(
      (Failure failure) {
        _seasonEpisodesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (List<TvSeasonEpisode> seasonEpisode) {
        _seasonEpisodesState = RequestState.loaded;
        _seasonEpisodes = seasonEpisode;
        notifyListeners();
      },
    );
  }
}
