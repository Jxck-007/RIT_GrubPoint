import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3PqvnKx1XQzyI5qLDyaHKXNjqZgLkTYw',
    appId: '1:572069152415:android:7acc11c540f71ce58544aa',
    messagingSenderId: '572069152415',
    projectId: 'rit-grubpoint',
    storageBucket: 'rit-grubpoint.appspot.com',
  );
} 