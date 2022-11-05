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

  final BehaviorSubject<List<Tv>> _tvs =
      BehaviorSubject<List<Tv>>.seeded(<Tv>[]);
  Stream<List<Tv>> get tvs => _tvs.stream.asBroadcastStream();

  final BehaviorSubject<RequestState> _state =
      BehaviorSubject<RequestState>.seeded(RequestState.empty);
  Stream<RequestState> get state => _state.stream.asBroadcastStream();

  Future<void> fetchPopularTvs() async {
    _state.add(RequestState.loading);

    final Either<Failure, List<Tv>> result =
        await getPopularTvsUsecase.execute();
    result.fold(
      (Failure failure) {
        _state.add(RequestState.error);
        message.add(failure.message);
      },
      (List<Tv> tvsData) {
        _state.add(RequestState.loaded);
        _tvs.add(tvsData);
      },
    );
  }

  @override
  void dispose() {
    _tvs.close();
    _state.close();
    super.dispose();
  }
}
