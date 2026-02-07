import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBkAG-c4c4u2PbZ0J3YRMkC49ZxX9fIX-E",
    appId: "1:1053573817442:android:84416808d90ba4e3b49d3b",
    messagingSenderId: "1053573817442",
    projectId: "flutter-project-2-c9919",
    storageBucket: "flutter-project-2-c9919.firebasestorage.app",
  );
}
