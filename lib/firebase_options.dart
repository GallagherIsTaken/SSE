// File generated manually based on google-services.json
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAu87kQJDkwGVVRt6rZVM60DpJXEtVfEuk',
    appId: '1:100077315251:web:3abc9f04e5e9a4d05f7cc6',
    messagingSenderId: '100077315251',
    projectId: 'sumbersentuhanemas-9b281',
    authDomain: 'sumbersentuhanemas-9b281.firebaseapp.com',
    storageBucket: 'sumbersentuhanemas-9b281.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAu87kQJDkwGVVRt6rZVM60DpJXEtVfEuk',
    appId: '1:100077315251:android:3460f2cb22e422755f7cc6',
    messagingSenderId: '100077315251',
    projectId: 'sumbersentuhanemas-9b281',
    storageBucket: 'sumbersentuhanemas-9b281.firebasestorage.app',
  );
}
