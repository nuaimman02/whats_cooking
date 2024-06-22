// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBSqKwyeJmpxQcGUn9BI3u1766UO0zy_sk',
    appId: '1:181435458777:web:026d4117b1053d911a8ac8',
    messagingSenderId: '181435458777',
    projectId: 'sse3401-project',
    authDomain: 'sse3401-project.firebaseapp.com',
    storageBucket: 'sse3401-project.appspot.com',
    measurementId: 'G-77J9VL4ETQ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgVX6Xwa_g641_GJMVhSEtI3UaO5AROLA',
    appId: '1:181435458777:android:1f229aa05a7dfb441a8ac8',
    messagingSenderId: '181435458777',
    projectId: 'sse3401-project',
    storageBucket: 'sse3401-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAp3c_LE1Q5yFJdIO2gRypN8fQn5ljvfSk',
    appId: '1:181435458777:ios:a489998c862bd19c1a8ac8',
    messagingSenderId: '181435458777',
    projectId: 'sse3401-project',
    storageBucket: 'sse3401-project.appspot.com',
    iosBundleId: 'com.example.whatsCooking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAp3c_LE1Q5yFJdIO2gRypN8fQn5ljvfSk',
    appId: '1:181435458777:ios:a489998c862bd19c1a8ac8',
    messagingSenderId: '181435458777',
    projectId: 'sse3401-project',
    storageBucket: 'sse3401-project.appspot.com',
    iosBundleId: 'com.example.whatsCooking',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBSqKwyeJmpxQcGUn9BI3u1766UO0zy_sk',
    appId: '1:181435458777:web:c373fe3742cced861a8ac8',
    messagingSenderId: '181435458777',
    projectId: 'sse3401-project',
    authDomain: 'sse3401-project.firebaseapp.com',
    storageBucket: 'sse3401-project.appspot.com',
    measurementId: 'G-NKN2Q9Z5X4',
  );

}