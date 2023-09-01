import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for macOS - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macOS - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'AIzaSyD38T4r-dm2193VtylfdI4MWPE6_ZBY6Qs',
     appId: '1:953677166111:android:1f9ddafe28564776fac72a',
     messagingSenderId: '953677166111',
     projectId: 'vietnamtravelapp',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAStBr_--t3u6LrBXQafXvfWef1AcWBFkI',
    appId: '1:953677166111:ios:12a6b8bded28fcdbfac72a',
    messagingSenderId: '764483782754',
    projectId: 'vietnamtravelapp',
    iosBundleId: 'com.example.mockBlocStream',
  );
}
