import 'package:mock_bloc_stream/core/extension/base_model.dart';

import 'tv_model.dart';

class TvResponse extends AppModel {
  factory TvResponse.fromJson(Map<String, dynamic> json) => TvResponse(
        tvList: List<TvModel>.from(
          (json['results'] as List<dynamic>)
              .map((dynamic x) => TvModel.fromJson(x as Map<String, dynamic>))
              .where(
                (TvModel element) =>
                    element.posterPath != null && element.backdropPath != null,
              ),
        ),
      );

  TvResponse({required this.tvList});
  final List<TvModel>? tvList;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'results': List<dynamic>.from(
          (tvList ?? <TvModel>[]).map((TvModel x) => x.toJson()),
        ),
      };
}
