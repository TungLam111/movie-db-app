import 'package:mock_bloc_stream/core/extension/base_model.dart';

class Genre extends AppEntity {
  Genre({
    required this.id,
    required this.name,
  });
  final int id;
  final String? name;
}
