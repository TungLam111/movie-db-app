import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/utils/enum.dart';

class HomeNotifier extends ChangeNotifier {
  GeneralContentType _state = GeneralContentType.movie;

  GeneralContentType get state => _state;

  void setState(GeneralContentType newState) {
    _state = newState;
    notifyListeners();
  }
}
