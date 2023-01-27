import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final BehaviorSubject<String> messageSubject =
      BehaviorSubject<String>.seeded('');
  Stream<String> get messageStream => messageSubject.stream.asBroadcastStream();
  String get getMessage => messageSubject.value;

  @mustCallSuper
  void dispose() {
    messageSubject.close();
  }
}
