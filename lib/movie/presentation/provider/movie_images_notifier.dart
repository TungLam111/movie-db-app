import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/media_image.dart';
import '../../domain/usecases/get_movie_images_usecase.dart';

class MovieImagesNotifier extends ChangeNotifier {
  MovieImagesNotifier({required this.getMovieImages});
  final GetMovieImagesUsecase getMovieImages;

  late MediaImage _movieImages;
  MediaImage get movieImages => _movieImages;

  RequestState _movieImagesState = RequestState.empty;
  RequestState get movieImagesState => _movieImagesState;

  String _message = '';
  String get message => _message;

  Future<void> fetchMovieImages(int id) async {
    _movieImagesState = RequestState.loading;
    notifyListeners();

    final Either<Failure, MediaImage> result = await getMovieImages.execute(id);
    result.fold(
      (Failure failure) {
        _movieImagesState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (MediaImage movieImages) {
        _movieImagesState = RequestState.loaded;
        _movieImages = movieImages;
        notifyListeners();
      },
    );
  }
}
