import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/media_image.dart';
import '../../domain/usecases/get_tv_images_usecase.dart';

class TvImagesBloc extends BaseBloc {
  TvImagesBloc({required this.getTvImagesUsecase});
  final GetTvImagesUsecase getTvImagesUsecase;

  final BehaviorSubject<MediaImage?> _tvImages =
      BehaviorSubject<MediaImage?>.seeded(null);
  Stream<MediaImage?> get tvImagesStream =>
      _tvImages.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _tvImagesState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get tvImagesStateStream => _tvImagesState.stream;

  Future<void> fetchTvImages(int id) async {
    _tvImagesState.add(RequestState.loading);

    final Either<Failure, MediaImage> result =
        await getTvImagesUsecase.execute(id);
    result.fold(
      (Failure failure) {
        _tvImagesState.add(RequestState.error);
        message.add(failure.message);
      },
      (MediaImage tvImages) {
        _tvImagesState.add(RequestState.loaded);
        _tvImages.add(tvImages);
      },
    );
  }

  @override
  void dispose() {
    _tvImages.close();
    _tvImagesState.close();
    super.dispose();
  }
}
