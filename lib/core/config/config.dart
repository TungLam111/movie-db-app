import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/config/env/network_config.dart';
import 'package:mock_bloc_stream/core/config/firebase_option.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';

class AppConfig {
  AppConfig._();

  factory AppConfig() {
    return _appConfig;
  }

  static final AppConfig _appConfig = AppConfig._();

  Future<void> configApp({required BuildMode buildMode}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
       options:  DefaultFirebaseOptions.currentPlatform,
    );

    await initDependency(buildMode: buildMode);
  }
}
