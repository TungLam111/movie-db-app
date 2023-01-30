import 'package:equatable/equatable.dart';

import '../../domain/entities/media_image.dart';

class MediaMovieImageModel extends Equatable {
  factory MediaMovieImageModel.fromJson(Map<String, dynamic> json) =>
      MediaMovieImageModel(
        id: json['id'] as int,
        backdropPaths: List<String>.from(
          (json['backdrops'] as List<dynamic>)
              .map((dynamic x) => x['file_path']),
        ),
        logoPaths: List<String>.from(
          (json['logos'] as List<dynamic>).map((dynamic x) => x['file_path']),
        ),
        posterPaths: List<String>.from(
          (json['posters'] as List<dynamic>).map((dynamic x) => x['file_path']),
        ),
      );

  const MediaMovieImageModel({
    required this.id,
    required this.backdropPaths,
    required this.logoPaths,
    required this.posterPaths,
  });
  final int id;
  final List<String> backdropPaths;
  final List<String> logoPaths;
  final List<String> posterPaths;

  MediaImage toEntity() => MediaImage(
        id: id,
        backdropPaths: backdropPaths,
        logoPaths: logoPaths,
        posterPaths: posterPaths,
      );

  @override
  List<Object?> get props => <Object?>[
        id,
        backdropPaths,
        logoPaths,
        posterPaths,
      ];
}
