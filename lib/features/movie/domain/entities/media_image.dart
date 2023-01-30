import 'package:equatable/equatable.dart';

class MediaImage extends Equatable {
  const MediaImage({
    required this.id,
    required this.backdropPaths,
    required this.logoPaths,
    required this.posterPaths,
  });
  final int id;
  final List<String> backdropPaths;
  final List<String> logoPaths;
  final List<String> posterPaths;

  @override
  List<Object?> get props =>
      <Object?>[id, backdropPaths, logoPaths, posterPaths];
}
