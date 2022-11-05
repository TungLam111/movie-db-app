import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_on_the_air_tvs_usecase.dart';
import '../../domain/usecases/get_popular_tvs_usecase.dart';
import '../../domain/usecases/get_top_rated_tvs_usecase.dart';

class TvListNotifier extends ChangeNotifier {
  TvListNotifier({
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  });
  List<Tv> _onTheAirTvs = <Tv>[];
  List<Tv> get onTheAirTvs => _onTheAirTvs;

  RequestState _onTheAirTvsState = RequestState.empty;
  RequestState get onTheAirTvsState => _onTheAirTvsState;

  List<Tv> _popularTvs = <Tv>[];
  List<Tv> get popularTvs => _popularTvs;

  RequestState _popularTvsState = RequestState.empty;
  RequestState get popularTvsState => _popularTvsState;

  List<Tv> _topRatedTvs = <Tv>[];
  List<Tv> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvsState = RequestState.empty;
  RequestState get topRatedTvsState => _topRatedTvsState;

  String _message = '';
  String get message => _message;

  final GetOnTheAirTvsUsecase getOnTheAirTvs;
  final GetPopularTvsUsecase getPopularTvs;
  final GetTopRatedTvsUsecase getTopRatedTvs;

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirTvsState = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<Tv>> result = await getOnTheAirTvs.execute();
    result.fold(
      (Failure failure) {
        _onTheAirTvsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (List<Tv> tvsData) {
        _onTheAirTvsState = RequestState.loaded;
        _onTheAirTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvsState = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<Tv>> result = await getPopularTvs.execute();
    result.fold(
      (Failure failure) {
        _popularTvsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (List<Tv> tvsData) {
        _popularTvsState = RequestState.loaded;
        _popularTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvsState = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<Tv>> result = await getTopRatedTvs.execute();
    result.fold(
      (Failure failure) {
        _topRatedTvsState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (List<Tv> tvsData) {
        _topRatedTvsState = RequestState.loaded;
        _topRatedTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
