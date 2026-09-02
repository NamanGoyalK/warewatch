import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:warewatch/core/services/firebase_options.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    try {
      // 1. Check if an app is already initialized
      if (Firebase.apps.isNotEmpty) {
        if (kDebugMode) {
          print(">> Firebase: Already initialized, skipping duplicate call.");
        }
        return;
      }

      // 2. If not, initialize it
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        print(">> Firebase: Successfully initialized [DEFAULT].");
      }
    } catch (e) {
      // 3. Catch the duplicate error if the logic above somehow misses it
      if (e.toString().contains('duplicate-app')) {
        if (kDebugMode) {
          print(">> Firebase: Caught duplicate app error, continuing safely.");
        }
      } else {
        if (kDebugMode) {
          print(">> Firebase: Critical Init Error: $e");
        }
        rethrow;
      }
    }
  }
}
