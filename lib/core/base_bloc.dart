import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseBloc {
  final BehaviorSubject<String> message = BehaviorSubject<String>.seeded('');
  Stream<String> get messageStream => message.stream.asBroadcastStream();
  String get getMessage => message.value;

  @mustCallSuper
  void dispose() {
    message.close();
  }
}
