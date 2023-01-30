import 'package:flutter/material.dart';
import 'package:mock_bloc_stream/core/config/env/network_config.dart';
import 'package:mock_bloc_stream/injection/di_locator.dart';

class AppConfig {
  AppConfig._();

  factory AppConfig() {
    return _appConfig;
  }

  static final AppConfig _appConfig = AppConfig._();

  Future<void> configApp({required BuildMode buildMode}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await initDependency(buildMode: buildMode);
  }
}
