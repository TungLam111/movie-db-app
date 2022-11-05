import 'package:equatable/equatable.dart';

import 'tv_model.dart';

class TvResponse extends Equatable {
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

  const TvResponse({required this.tvList});
  final List<TvModel> tvList;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'results': List<dynamic>.from(tvList.map((TvModel x) => x.toJson())),
      };

  @override
  List<Object?> get props => <Object?>[tvList];
}
