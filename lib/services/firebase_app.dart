import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

/// Firebase initialization. Call before runApp.
class FirebaseAppService {
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _initialized = true;
      return true;
    } catch (_) {
      return false;
    }
  }
}
