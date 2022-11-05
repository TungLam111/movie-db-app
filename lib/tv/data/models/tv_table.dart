import 'package:equatable/equatable.dart';

import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';

class TvTable extends Equatable {
  factory TvTable.fromEntity(TvDetail tv) => TvTable(
        firstAirDate: tv.firstAirDate,
        id: tv.id,
        name: tv.name,
        overview: tv.overview,
        posterPath: tv.posterPath,
        voteAverage: tv.voteAverage,
      );

  const TvTable({
    required this.firstAirDate,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvTable.fromMap(Map<String, dynamic> map) => TvTable(
        firstAirDate: map['firstAirDate'] as String?,
        id: map['id'] as int,
        name: map['name'] as String?,
        overview: map['overview'] as String?,
        posterPath: map['posterPath'] as String?,
        voteAverage: (map['voteAverage'] as num?)?.toDouble(),
      );
  final String? firstAirDate;
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final double? voteAverage;

  Map<String, dynamic> toMap() => <String, dynamic>{
        'firstAirDate': firstAirDate,
        'id': id,
        'name': name,
        'overview': overview,
        'posterPath': posterPath,
        'voteAverage': voteAverage,
      };

  Tv toEntity() => Tv.watchList(
        firstAirDate: firstAirDate,
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );

  @override
  List<Object?> get props => <Object?>[
        firstAirDate,
        id,
        name,
        overview,
        posterPath,
        voteAverage,
      ];
}
