import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for android - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyAh8gX0YnGn3XxqH48nlb1AnN1UeaYKUY4',
    appId: '1:959799209604:web:6617970ea499ae3f2cdcd1',
    messagingSenderId: '959799209604',
    projectId: 'flutter-tourism-62f6b',
    authDomain: 'flutter-tourism-62f6b.firebaseapp.com',
    storageBucket: 'flutter-tourism-62f6b.firebasestorage.app',
    measurementId: 'G-X2BF2TRBBD',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAB76WvKo0zRXFQ0xaZyPI3OShjMBCrqpA',
    appId: '1:959799209604:ios:9a515705d6db69ef2cdcd1',
    messagingSenderId: '959799209604',
    projectId: 'flutter-tourism-62f6b',
    storageBucket: 'flutter-tourism-62f6b.firebasestorage.app',
    iosBundleId: 'com.example.pizzeriaApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAh8gX0YnGn3XxqH48nlb1AnN1UeaYKUY4',
    appId: '1:959799209604:web:d65bd3cb9a72db982cdcd1',
    messagingSenderId: '959799209604',
    projectId: 'flutter-tourism-62f6b',
    authDomain: 'flutter-tourism-62f6b.firebaseapp.com',
    storageBucket: 'flutter-tourism-62f6b.firebasestorage.app',
    measurementId: 'G-PJTHXN80FS',
  );

}