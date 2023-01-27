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

  final BehaviorSubject<MediaImage?> _movieImagesSubject =
      BehaviorSubject<MediaImage?>.seeded(null);
  Stream<MediaImage?> get getMediaImageStream =>
      _movieImagesSubject.stream.asBroadcastStream();
  MediaImage? get movieImages => _movieImagesSubject.value;

  final BehaviorSubject<RequestState> _movieImagesStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get getMovieImagesStateStream =>
      _movieImagesStateSubject.stream.asBroadcastStream();
  RequestState get movieImagesState => _movieImagesStateSubject.value;

  Future<void> fetchMovieImages(int id) async {
    _movieImagesStateSubject.add(RequestState.loading);

    final Either<Failure, MediaImage> result =
        await getMovieImagesUsecase.execute(id);
    result.fold(
      (Failure failure) {
        _movieImagesStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (MediaImage movieImages) {
        _movieImagesStateSubject.add(RequestState.loaded);
        _movieImagesSubject.add(movieImages);
      },
    );
  }

  @override
  void dispose() {
    _movieImagesSubject.close();
    _movieImagesStateSubject.close();
    super.dispose();
  }
}
