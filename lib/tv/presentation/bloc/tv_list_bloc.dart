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
  final BehaviorSubject<List<Tv>> _onTheAirTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get onTheAirTvsStream =>
      _onTheAirTvsSubject.stream.asBroadcastStream();
  List<Tv> get onTheAirTvs => _onTheAirTvsSubject.value;

  final BehaviorSubject<RequestState> _onTheAirTvsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get onTheAirTvsStateStream =>
      _onTheAirTvsStateSubject.stream.asBroadcastStream();

  final BehaviorSubject<List<Tv>> _popularTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get popularTvsStream =>
      _popularTvsSubject.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _popularTvsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get popularTvsStateStream =>
      _popularTvsStateSubject.stream.asBroadcastStream();

  final BehaviorSubject<List<Tv>> _topRatedTvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get topRatedTvsStream =>
      _topRatedTvsSubject.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _topRatedTvsStateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get topRatedTvsStateStream =>
      _topRatedTvsStateSubject.stream.asBroadcastStream();

  final GetOnTheAirTvsUsecase getOnTheAirTvsUsecase;
  final GetPopularTvsUsecase getPopularTvsUsecase;
  final GetTopRatedTvsUsecase getTopRatedTvsUsecase;

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirTvsStateSubject.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getOnTheAirTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _onTheAirTvsStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (List<Tv> tvsData) {
        _onTheAirTvsStateSubject.add(RequestState.loaded);
        _onTheAirTvsSubject.add(tvsData);
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsStateSubject.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getPopularTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _popularTvsStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (List<Tv> tvsData) {
        _popularTvsStateSubject.add(RequestState.loaded);
        _popularTvsSubject.add(tvsData);
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsStateSubject.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getTopRatedTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _topRatedTvsStateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (List<Tv> tvsData) {
        _topRatedTvsStateSubject.add(RequestState.loaded);
        _topRatedTvsSubject.add(tvsData);
      },
    );
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
