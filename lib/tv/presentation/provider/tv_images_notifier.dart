import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/media_image.dart';
import '../../domain/usecases/get_tv_images_usecase.dart';

class TvImagesNotifier extends ChangeNotifier {
  TvImagesNotifier({required this.getTvImages});
  final GetTvImagesUsecase getTvImages;

  late MediaImage _tvImages;
  MediaImage get tvImages => _tvImages;

  RequestState _tvImagesState = RequestState.empty;
  RequestState get tvImagesState => _tvImagesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchTvImages(int id) async {
    _tvImagesState = RequestState.loading;
    notifyListeners();

    final Either<Failure, MediaImage> result = await getTvImages.execute(id);
    result.fold(
      (Failure failure) {
        _tvImagesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (MediaImage tvImages) {
        _tvImagesState = RequestState.loaded;
        _tvImages = tvImages;
        notifyListeners();
      },
    );
  }
}
