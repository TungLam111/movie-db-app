import 'package:mock_bloc_stream/core/extension/base_model.dart';

import 'tv_season_episode_model.dart';

class TvSeasonEpisodeResponse extends AppModel {
  factory TvSeasonEpisodeResponse.fromJson(Map<String, dynamic> json) =>
      TvSeasonEpisodeResponse(
        tvEpisodes: List<TvSeasonEpisodeModel>.from(
          (json['episodes'] as List<dynamic>)
              .map(
                (dynamic x) =>
                    TvSeasonEpisodeModel.fromJson(x as Map<String, dynamic>),
              )
              .where(
                (TvSeasonEpisodeModel element) => element.stillPath != null,
              ),
        ),
      );

  TvSeasonEpisodeResponse({
    required this.tvEpisodes,
  });
  final List<TvSeasonEpisodeModel>? tvEpisodes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'episodes': List<dynamic>.from(
          (tvEpisodes ?? <TvSeasonEpisodeModel>[])
              .map((TvSeasonEpisodeModel x) => x.toJson()),
        ),
      };
}
