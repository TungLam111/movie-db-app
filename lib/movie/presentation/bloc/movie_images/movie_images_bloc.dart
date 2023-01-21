import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/media_image.dart';
import '../../../domain/usecases/get_movie_images_usecase.dart';

class MovieImagesBloc extends BaseBloc {
  MovieImagesBloc({required this.getMovieImagesUsecase});
  final GetMovieImagesUsecase getMovieImagesUsecase;

  final BehaviorSubject<MediaImage?> _movieImages =
      BehaviorSubject<MediaImage?>.seeded(null);
  Stream<MediaImage?> get getMediaImageStream =>
      _movieImages.stream.asBroadcastStream();
  MediaImage? get movieImages => _movieImages.value;

  final BehaviorSubject<RequestState> _movieImagesState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get getMovieImagesStateStream =>
      _movieImagesState.stream.asBroadcastStream();
  RequestState get movieImagesState => _movieImagesState.value;

  Future<void> fetchMovieImages(int id) async {
    _movieImagesState.add(RequestState.loading);

    final Either<Failure, MediaImage> result =
        await getMovieImagesUsecase.execute(id);
    result.fold(
      (Failure failure) {
        _movieImagesState.add(RequestState.error);
        message.add(failure.message);
      },
      (MediaImage movieImages) {
        _movieImagesState.add(RequestState.loaded);
        _movieImages.add(movieImages);
      },
    );
  }

  @override
  void dispose() {
    _movieImages.close();
    _movieImagesState.close();
    super.dispose();
  }
}
