import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/media_image.dart';
import '../../domain/usecases/get_tv_images_usecase.dart';

class TvImagesBloc extends BaseBloc {
  TvImagesBloc({required this.getTvImagesUsecase});
  final GetTvImagesUsecase getTvImagesUsecase;

  final BehaviorSubject<MediaImage?> _tvImagesSubject =
      BehaviorSubject<MediaImage?>.seeded(null);
  Stream<MediaImage?> get tvImagesStream =>
      _tvImagesSubject.stream;

  final BehaviorSubject<RequestState> _tvImagesStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get tvImagesStateStream => _tvImagesStateSubject.stream;

  Future<void> fetchTvImages(int id) async {
    _tvImagesStateSubject.add(RequestState.loading);

    final Either<Failure, MediaImage> result =
        await getTvImagesUsecase.execute(id);
    result.fold(
      (Failure failure) {
        _tvImagesStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (MediaImage tvImages) {
        _tvImagesStateSubject.add(RequestState.loaded);
        _tvImagesSubject.add(tvImages);
      },
    );
  }

  @override
  void dispose() {
    _tvImagesSubject.close();
    _tvImagesStateSubject.close();
    super.dispose();
  }
}
