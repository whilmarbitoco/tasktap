import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FirebaseConfig {
  static FirebaseOptions get currentPlatform {
    return FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: '${dotenv.env['FIREBASE_PROJECT_ID']}.appspot.com',
    );
  }

  static void validateConfig() {
    final requiredKeys = [
      'FIREBASE_API_KEY',
      'FIREBASE_PROJECT_ID',
      'FIREBASE_MESSAGING_SENDER_ID',
      'FIREBASE_APP_ID',
    ];

    for (String key in requiredKeys) {
      if (dotenv.env[key] == null || dotenv.env[key]!.contains('your_')) {
        throw Exception('Missing or invalid Firebase configuration: $key');
      }
    }
  }
}