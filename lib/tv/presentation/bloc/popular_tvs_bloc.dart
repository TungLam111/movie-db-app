import 'package:dartz/dartz.dart';
import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/common_util.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_popular_tvs_usecase.dart';

class PopularTvsBloc extends BaseBloc {
  PopularTvsBloc(this.getPopularTvsUsecase);
  final GetPopularTvsUsecase getPopularTvsUsecase;

  final BehaviorSubject<List<Tv>> _tvsSubject =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get tvs => _tvsSubject.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _stateSubject =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get state => _stateSubject.stream.asBroadcastStream();

  Future<void> fetchPopularTvs() async {
    _stateSubject.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getPopularTvsUsecase.execute();
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
