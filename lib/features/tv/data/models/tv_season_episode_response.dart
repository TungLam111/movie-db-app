import 'package:equatable/equatable.dart';

import 'tv_season_episode_model.dart';

class TvSeasonEpisodeResponse extends Equatable {
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

  const TvSeasonEpisodeResponse({
    required this.tvEpisodes,
  });
  final List<TvSeasonEpisodeModel> tvEpisodes;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'episodes': List<dynamic>.from(
          tvEpisodes.map((TvSeasonEpisodeModel x) => x.toJson()),
        ),
      };

  @override
  List<Object?> get props => <Object?>[
        tvEpisodes,
      ];
}
