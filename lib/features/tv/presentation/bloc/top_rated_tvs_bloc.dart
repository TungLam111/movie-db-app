import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_top_rated_tvs_usecase.dart';

class TopRatedTvsBloc extends BaseBloc {
  TopRatedTvsBloc(this.getTopRatedTvsUsecase);
  final GetTopRatedTvsUsecase getTopRatedTvsUsecase;

  final BehaviorSubject<List<Tv>> _tvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get tvs => _tvsSubject.stream;

  final BehaviorSubject<RequestState> _stateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get state => _stateSubject.stream;

  Future<void> fetchTopRatedTvs() async {
    _stateSubject.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getTopRatedTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _stateSubject.add(RequestState.error);
        messageSubject.add(failure.message);
      },
      (List<Tv> tvsData) {
        _stateSubject.add(RequestState.loaded);
        _tvsSubject.add(tvsData);
      },
    );
  }

  @override
  void dispose() {
    _tvsSubject.close();
    _stateSubject.close();
    super.dispose();
  }
}
