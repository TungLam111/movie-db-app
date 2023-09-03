import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/core/base/data_state.dart';
import 'package:mock_bloc_stream/features/tv/domain/entities/media_image.dart';
import 'package:mock_bloc_stream/features/tv/domain/usecases/get_tv_images_usecase.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_on_the_air_tvs_usecase.dart';
import '../../domain/usecases/get_popular_tvs_usecase.dart';
import '../../domain/usecases/get_top_rated_tvs_usecase.dart';

class TvListBloc extends BaseBloc {
  TvListBloc({
    required this.getOnTheAirTvsUsecase,
    required this.getPopularTvsUsecase,
    required this.getTopRatedTvsUsecase,
    required this.getTvImagesUsecase,
  });
  final BehaviorSubject<List<Tv>> _onTheAirTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get onTheAirTvsStream => _onTheAirTvsSubject.stream;
  List<Tv> get onTheAirTvs => _onTheAirTvsSubject.value;

  final BehaviorSubject<RequestState> _onTheAirTvsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get onTheAirTvsStateStream =>
      _onTheAirTvsStateSubject.stream;

  final BehaviorSubject<List<Tv>> _popularTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get popularTvsStream => _popularTvsSubject.stream;

  final BehaviorSubject<RequestState> _popularTvsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get popularTvsStateStream =>
      _popularTvsStateSubject.stream;

  final BehaviorSubject<List<Tv>> _topRatedTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get topRatedTvsStream => _topRatedTvsSubject.stream;

  final BehaviorSubject<RequestState> _topRatedTvsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get topRatedTvsStateStream =>
      _topRatedTvsStateSubject.stream;

  final BehaviorSubject<MediaImage?> _tvImagesSubject =
      BehaviorSubject<MediaImage?>.seeded(null);
  Stream<MediaImage?> get tvImagesStream => _tvImagesSubject.stream;

  final BehaviorSubject<RequestState> _tvImagesStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get tvImagesStateStream => _tvImagesStateSubject.stream;

  final GetOnTheAirTvsUsecase getOnTheAirTvsUsecase;
  final GetPopularTvsUsecase getPopularTvsUsecase;
  final GetTopRatedTvsUsecase getTopRatedTvsUsecase;
  final GetTvImagesUsecase getTvImagesUsecase;

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirTvsStateSubject.add(RequestState.loading);

    final DataState<List<Tv>> result = await getOnTheAirTvsUsecase.execute();
    if (result.isError()) {
      _onTheAirTvsStateSubject.add(RequestState.error);
      messageSubject.add(result.err);
    } else {
      _onTheAirTvsStateSubject.add(RequestState.loaded);
      _onTheAirTvsSubject.add(result.data!);
    }
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsStateSubject.add(RequestState.loading);

    final DataState<List<Tv>> result = await getPopularTvsUsecase.execute(1);
    if (result.isError()) {
      _popularTvsStateSubject.add(RequestState.error);
      messageSubject.add(result.err);
    } else {
      _popularTvsStateSubject.add(RequestState.loaded);
      _popularTvsSubject.add(result.data!);
    }
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsStateSubject.add(RequestState.loading);

    final DataState<List<Tv>> result = await getTopRatedTvsUsecase.execute(1);
    if (result.isError()) {
      _topRatedTvsStateSubject.add(RequestState.error);
      messageSubject.add(result.err);
    } else {
      _topRatedTvsStateSubject.add(RequestState.loaded);
      _topRatedTvsSubject.add(result.data!);
    }
  }

  Future<void> fetchTvImages(int id) async {
    _tvImagesStateSubject.add(RequestState.loading);

    final DataState<MediaImage> result = await getTvImagesUsecase.execute(id);
    if (result.isError()) {
      _tvImagesStateSubject.add(RequestState.error);
      messageSubject.add(result.err);
    } else {
      _tvImagesStateSubject.add(RequestState.loaded);
      _tvImagesSubject.add(result.data);
    }
  }

  @override
  void dispose() {
    _onTheAirTvsSubject.close();
    _onTheAirTvsStateSubject.close();
    _popularTvsSubject.close();
    _popularTvsStateSubject.close();
    _topRatedTvsSubject.close();
    _topRatedTvsStateSubject.close();
    super.dispose();
  }
}
