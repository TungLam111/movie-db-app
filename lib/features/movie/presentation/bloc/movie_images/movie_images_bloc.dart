import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/entities/media_image.dart';
import '../../../domain/usecases/get_movie_images_usecase.dart';

class MovieImagesBloc extends BaseBloc {
  MovieImagesBloc({required this.getMovieImagesUsecase});
  final GetMovieImagesUsecase getMovieImagesUsecase;

  final BehaviorSubject<MediaImage?> _movieImagesSubject =
      BehaviorSubject<MediaImage?>.seeded(null);
  Stream<MediaImage?> get getMediaImageStream => _movieImagesSubject.stream;
  MediaImage? get movieImages => _movieImagesSubject.value;

  final BehaviorSubject<RequestState> _movieImagesStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get getMovieImagesStateStream =>
      _movieImagesStateSubject.stream;
  RequestState get movieImagesState => _movieImagesStateSubject.value;

  Future<void> fetchMovieImages(int id) async {
    _movieImagesStateSubject.add(RequestState.loading);

    final DataState<MediaImage> result =
        await getMovieImagesUsecase.execute(id);
    if (result.isError()) {
      _movieImagesStateSubject.add(RequestState.error);
      messageSubject.add(result.err);
    } else {
      _movieImagesStateSubject.add(RequestState.loaded);
      _movieImagesSubject.add(result.data);
    }
  }

  @override
  void dispose() {
    _movieImagesSubject.close();
    _movieImagesStateSubject.close();
    super.dispose();
  }
}
