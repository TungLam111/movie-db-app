import 'package:mock_bloc_stream/core/base_bloc.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc {
  HomeBloc() {
    _state.stream.listen(_onStateChange);
  }
  final BehaviorSubject<GeneralContentType> _state =
      BehaviorSubject<GeneralContentType>.seeded(GeneralContentType.movie);

  Stream<GeneralContentType> get state => _state.stream.asBroadcastStream();

  @override
  void dispose() {
    _state.close();
    super.dispose();
  }

  void _onStateChange(GeneralContentType newState) {}

  void setState(GeneralContentType newState) {
    _state.add(newState);
  }
}
