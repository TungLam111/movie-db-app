import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_popular_tvs_usecase.dart';

class PopularTvsNotifier extends ChangeNotifier {
  PopularTvsNotifier(this.getPopularTvs);
  final GetPopularTvsUsecase getPopularTvs;

  List<Tv> _tvs = <Tv>[];
  List<Tv> get tvs => _tvs;

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvs() async {
    _state = RequestState.loading;
    notifyListeners();

    final Either<Failure, List<Tv>> result = await getPopularTvs.execute();
    result.fold(
      (Failure failure) {
        _state = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (List<Tv> tvsData) {
        _state = RequestState.loaded;
        _tvs = tvsData;
        notifyListeners();
      },
    );
  }
}
