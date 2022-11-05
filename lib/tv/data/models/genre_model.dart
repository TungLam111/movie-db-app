import 'package:equatable/equatable.dart';

import 'package:mock_bloc_stream/tv/domain/entities/genre.dart';

class GenreModel extends Equatable {
  const GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) => GenreModel(
        id: json['id'] as int,
        name: json['name'] as String,
      );
  final int id;
  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };

  Genre toEntity() => Genre(
        id: id,
        name: name,
      );

  @override
  List<Object?> get props => <Object?>[id, name];
}
