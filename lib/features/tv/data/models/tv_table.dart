import 'package:json_annotation/json_annotation.dart';
import 'package:mock_bloc_stream/core/extension/base_model.dart';

import '../../domain/entities/tv.dart';
import '../../domain/entities/tv_detail.dart';
part 'tv_table.g.dart';

@JsonSerializable()
class TvTable extends AppModel {
  factory TvTable.fromEntity(TvDetail tv) => TvTable(
        firstAirDate: tv.firstAirDate,
        id: tv.id,
        name: tv.name,
        overview: tv.overview,
        posterPath: tv.posterPath,
        voteAverage: tv.voteAverage,
      );

  TvTable({
    required this.firstAirDate,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvTable.fromMap(Map<String, dynamic> json) => _$TvTableFromJson(json);

  Map<String, dynamic> toMap() => _$TvTableToJson(this);

  final String? firstAirDate;
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final double? voteAverage;

  Tv toEntity() => Tv.watchList(
        firstAirDate: firstAirDate,
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
        voteAverage: voteAverage,
      );
}
