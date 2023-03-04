import 'package:firebase_core/firebase_core.dart';
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
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyD38T4r-dm2193VtylfdI4MWPE6_ZBY6Qs',
        appId: '1:953677166111:android:1f9ddafe28564776fac72a',
        messagingSenderId: '953677166111',
        projectId: 'vietnamtravelapp',
      ),
    );

    await initDependency(buildMode: buildMode);
  }
}
