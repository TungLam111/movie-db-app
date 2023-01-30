import 'dart:developer';

import 'package:mock_bloc_stream/core/base/base_bloc.dart';
import 'package:mock_bloc_stream/utils/enum.dart';
import 'package:rxdart/rxdart.dart';

void logg(dynamic a) {
  log(a.toString());
}

class HomeBloc extends BaseBloc {
  HomeBloc() {
    _stateSubject.stream.listen(_onStateChange);

  }
  final BehaviorSubject<GeneralContentType> _stateSubject =
      BehaviorSubject<GeneralContentType>.seeded(GeneralContentType.movie);

  Stream<GeneralContentType> get stateStream => _stateSubject.stream;

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
