import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions not configured for this platform. '
          'Run `flutterfire configure` to regenerate.',
        );
    }
  }

  // ------------------------------------------------------------------ Android
  // Get these from Firebase Console → Project settings → Your apps → Android
  static const FirebaseOptions android = FirebaseOptions(
    // TODO: Replace these 4 fields with your Firebase project's real values:
    apiKey: 'AIzaSy-REPLACE-ME-WITH-REAL-API-KEY-FROM-FIREBASE-CONSOLE',
    appId: '1:REPLACE-ME:android:xxxxxxxxxxxxxxxx',
    messagingSenderId: 'REPLACE_ME_12_DIGIT_SENDER_ID',
    projectId: 'REPLACE_ME_WITH_FIREBASE_PROJECT_ID',
    // Optional — these are auto-derived but safe to leave:
    storageBucket: 'REPLACE_ME_WITH_FIREBASE_PROJECT_ID.appspot.com',
  );

  // ------------------------------------------------------------------ Web/iOS
  // (Filled once you run flutterfire configure. These stubs are placeholders.)
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'stub-web-api-key-run-flutterfire-configure',
    appId: '1:stub:web:stub',
    messagingSenderId: '000000000000',
    projectId: 'grocery-app-stub',
    authDomain: 'grocery-app-stub.firebaseapp.com',
    storageBucket: 'grocery-app-stub.appspot.com',
    measurementId: 'G-STUB',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'stub-ios-api-key-run-flutterfire-configure',
    appId: '1:000000000000:ios:stub',
    messagingSenderId: '000000000000',
    projectId: 'grocery-app-stub',
    storageBucket: 'grocery-app-stub.appspot.com',
    iosBundleId: 'com.example.groceryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'stub-macos-api-key',
    appId: '1:000000000000:ios:stub',
    messagingSenderId: '000000000000',
    projectId: 'grocery-app-stub',
    storageBucket: 'grocery-app-stub.appspot.com',
    iosBundleId: 'com.example.groceryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'stub-windows-api-key',
    appId: '1:000000000000:web:stub',
    messagingSenderId: '000000000000',
    projectId: 'grocery-app-stub',
    authDomain: 'grocery-app-stub.firebaseapp.com',
    storageBucket: 'grocery-app-stub.appspot.com',
  );
}
