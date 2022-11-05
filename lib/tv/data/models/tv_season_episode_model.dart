import 'package:equatable/equatable.dart';

import '../../domain/entities/tv_season_episode.dart';

class TvSeasonEpisodeModel extends Equatable {
  factory TvSeasonEpisodeModel.fromJson(Map<String, dynamic> json) =>
      TvSeasonEpisodeModel(
        airDate: json['air_date'] as String,
        episodeNumber: json['episode_number'] as int,
        id: json['id'] as int,
        name: json['name'] as String,
        overview: json['overview'] as String,
        seasonNumber: json['season_number'] as int,
        stillPath: json['still_path'] as String?,
        voteAverage: (json['vote_average'] as num).toDouble(),
        voteCount: json['vote_count'] as int,
      );

  const TvSeasonEpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });
  final String airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'air_date': airDate,
        'episode_number': episodeNumber,
        'id': id,
        'name': name,
        'overview': overview,
        'season_number': seasonNumber,
        'still_path': stillPath,
        'vote_average': voteAverage,
        'vote_count': voteCount,
      };

  TvSeasonEpisode toEntity() => TvSeasonEpisode(
        airDate: airDate,
        episodeNumber: episodeNumber,
        id: id,
        name: name,
        overview: overview,
        seasonNumber: seasonNumber,
        stillPath: stillPath,
        voteAverage: voteAverage,
        voteCount: voteCount,
      );

  @override
  List<Object?> get props => <Object?>[
        airDate,
        episodeNumber,
        id,
        name,
        overview,
        seasonNumber,
        stillPath,
        voteAverage,
        voteCount,
      ];
}
