import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final PublishSubject<String> messageSubject = PublishSubject<String>();
  Stream<String> get messageStream => messageSubject.stream;

  @mustCallSuper
  void dispose() {
    messageSubject.close();
  }
}
