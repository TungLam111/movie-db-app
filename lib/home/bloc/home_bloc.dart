import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc {
  HomeBloc() {
    _stateSubject.stream.listen(_onStateChange);
  }
  final BehaviorSubject<GeneralContentType> _stateSubject =
      BehaviorSubject<GeneralContentType>.seeded(GeneralContentType.movie);

  Stream<GeneralContentType> get state =>
      _stateSubject.stream.asBroadcastStream();

  @override
  void dispose() {
    _stateSubject.close();
    super.dispose();
  }

  void _onStateChange(GeneralContentType newState) {}

  void setState(GeneralContentType newState) {
    _stateSubject.add(newState);
  }
}
