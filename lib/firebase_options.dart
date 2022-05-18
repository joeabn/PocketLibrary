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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
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
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpG2I1K0M28M_uroMWdxmFyVO5DS-h9hE',
    appId: '1:710322801342:android:41f6b0486691ccc235acef',
    messagingSenderId: '710322801342',
    projectId: 'pocketlibrary-3872c',
    storageBucket: 'pocketlibrary-3872c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCo_zuHg_wuxhJLbetoBrzevM2gchQ_hbI',
    appId: '1:710322801342:ios:382412dc4fd2307b35acef',
    messagingSenderId: '710322801342',
    projectId: 'pocketlibrary-3872c',
    storageBucket: 'pocketlibrary-3872c.appspot.com',
    iosClientId:
        '710322801342-6siqufpm9d5tfeq5ff1bouterelu7kjv.apps.googleusercontent.com',
    iosBundleId: 'Joeabn.com.pocketLibrary',
  );
}