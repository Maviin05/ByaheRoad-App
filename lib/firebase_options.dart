import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // Adjust according to the platform you're targeting
    if (kIsWeb) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDD1ruZLO6Wxv6leQRlW4ND3JykVC7o5e0',
        appId: '1:89309792255:web:48252942fd471655c349ca',
        messagingSenderId: '89309792255',
        projectId: 'byaheroad-65a16',
        storageBucket: 'byaheroad-65a16.appspot.com',
        measurementId: 'G-10R45HTTYJ',
        authDomain: 'byaheroad-65a16.firebaseapp.com',
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return const FirebaseOptions(
        apiKey: 'AIzaSyDD1ruZLO6Wxv6leQRlW4ND3JykVC7o5e0',
        appId: '1:89309792255:web:48252942fd471655c349ca',
        messagingSenderId: '89309792255',
        projectId: 'byaheroad-65a16',
        storageBucket: 'byaheroad-65a16.appspot.com',
      );
    }
    throw UnsupportedError(
        'DefaultFirebaseOptions are not supported for this platform.');
  }
}
