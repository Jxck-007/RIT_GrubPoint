import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
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
<<<<<<< HEAD
    apiKey: 'AIzaSyA3PqvnKx1XQzyI5qLDyaHKXNjqZgLkTYw',
    appId: '1:572069152415:android:7acc11c540f71ce58544aa',
    messagingSenderId: '572069152415',
    projectId: 'rit-grubpoint',
=======
    apiKey: "AIzaSyA3PqvnKx1XQzyI5qLDyaHKXNjqZgLkTYw",
    appId: "1:572069152415:android:7acc11c540f71ce58544aa",
    messagingSenderId: "572069152415",
    projectId: "rit-grubpoint",
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
    storageBucket: 'rit-grubpoint.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
<<<<<<< HEAD
    apiKey: 'AIzaSyA3PqvnKx1XQzyI5qLDyaHKXNjqZgLkTYw',
    appId: '1:572069152415:web:7acc11c540f71ce58544aa',
    messagingSenderId: '572069152415',
    projectId: 'rit-grubpoint',
    authDomain: 'rit-grubpoint.firebaseapp.com',
    storageBucket: 'rit-grubpoint.appspot.com',
=======
    apiKey: "AIzaSyA3PqvnKx1XQzyl5qLDyaHKXNjqZgLkTYw",
    appId: "1:572069152415:web:59cf6f9f4e128d708544aa",
    messagingSenderId: "572069152415",
    projectId: "rit-grubpoint",
    authDomain: "rit-grubpoint.firebaseapp.com",
    storageBucket: "rit-grubpoint.firebasestorage.app",
    measurementId: "G-L16M4DEZ03",
>>>>>>> ee47cadfc7141dbdf450a21f77a6f5469d4e36f9
  );
} 