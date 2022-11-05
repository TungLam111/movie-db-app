import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
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
  });
  final BehaviorSubject<List<Tv>> _onTheAirTvs =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get onTheAirTvsStream =>
      _onTheAirTvs.stream.asBroadcastStream();
  List<Tv> get onTheAirTvs => _onTheAirTvs.value;

  final BehaviorSubject<RequestState> _onTheAirTvsState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get onTheAirTvsStateStream =>
      _onTheAirTvsState.stream.asBroadcastStream();

  final BehaviorSubject<List<Tv>> _popularTvs =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get popularTvsStream =>
      _popularTvs.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _popularTvsState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get popularTvsStateStream =>
      _popularTvsState.stream.asBroadcastStream();

  final BehaviorSubject<List<Tv>> _topRatedTvs =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get topRatedTvsStream =>
      _topRatedTvs.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _topRatedTvsState =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get topRatedTvsStateStream =>
      _topRatedTvsState.stream.asBroadcastStream();

  final GetOnTheAirTvsUsecase getOnTheAirTvsUsecase;
  final GetPopularTvsUsecase getPopularTvsUsecase;
  final GetTopRatedTvsUsecase getTopRatedTvsUsecase;

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirTvsState.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getOnTheAirTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _onTheAirTvsState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Tv> tvsData) {
        _onTheAirTvsState.add(RequestState.loaded);
        _onTheAirTvs.add(tvsData);
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsState.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getPopularTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _popularTvsState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Tv> tvsData) {
        _popularTvsState.add(RequestState.loaded);
        _popularTvs.add(tvsData);
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getTopRatedTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _topRatedTvsState.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Tv> tvsData) {
        _topRatedTvsState.add(RequestState.loaded);
        _topRatedTvs.add(tvsData);
      },
    );
  }

  @override
  void dispose() {
    _onTheAirTvs.close();
    _onTheAirTvsState.close();
    _popularTvs.close();
    _popularTvsState.close();
    _topRatedTvs.close();
    _topRatedTvsState.close();
    super.dispose();
  }
}
