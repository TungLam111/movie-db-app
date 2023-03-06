import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc {
  HomeBloc() {
    _stateSubject.stream.listen(_onStateChange);
  }
  final BehaviorSubject<HomePageTab> _stateSubject =
      BehaviorSubject<HomePageTab>.seeded(HomePageTab.movie);

  Stream<HomePageTab> get stateStream => _stateSubject.stream;

  @override
  void dispose() {
    _stateSubject.close();
    super.dispose();
  }

  void _onStateChange(HomePageTab newState) {}

  void setState(HomePageTab newState) {
    _stateSubject.add(newState);
  }
}
