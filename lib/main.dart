import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'views/login_page.dart';
import 'views/home_page.dart';
import 'views/profile_page.dart';
import 'widgets/error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    // Initialize Firebase (uses google-services.json automatically)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }

    runApp(const TaskTapApp());
  } catch (e) {
    runApp(ErrorApp(error: e.toString()));
  }
}

class TaskTapApp extends StatelessWidget {
  const TaskTapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskTap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFDE047), // yellow-300
          primary: const Color(0xFFF59E0B), // yellow-500
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ErrorScreen(error: error));
  }
}
