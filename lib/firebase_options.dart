// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDDov14ErFkCYZp7AsZDGeqluZiHdqjUhM',
    appId: '1:1089749150546:web:3361e31c0c5d8ce21d288b',
    messagingSenderId: '1089749150546',
    projectId: 'flutterproject1-28530',
    authDomain: 'flutterproject1-28530.firebaseapp.com',
    databaseURL: 'https://flutterproject1-28530-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutterproject1-28530.appspot.com',
    measurementId: 'G-HVQV87R0ZS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxSvVrXmBuBg_La1gu4NACfib1GoMq4N0',
    appId: '1:1089749150546:android:bda0d9d6d38474961d288b',
    messagingSenderId: '1089749150546',
    projectId: 'flutterproject1-28530',
    databaseURL: 'https://flutterproject1-28530-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutterproject1-28530.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkFZHF8isNnAovbO0zDxBKwY8Ig_4xdLY',
    appId: '1:1089749150546:ios:ccfc27bd8e33f1671d288b',
    messagingSenderId: '1089749150546',
    projectId: 'flutterproject1-28530',
    databaseURL: 'https://flutterproject1-28530-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutterproject1-28530.appspot.com',
    iosClientId: '1089749150546-brfol93ukbj2v47hi9c9nghhmc5ku09r.apps.googleusercontent.com',
    iosBundleId: 'com.example.loginapp',
  );
}
