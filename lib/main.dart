import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'views/login_page.dart';
import 'widgets/main_layout.dart';
import 'widgets/error_screen.dart';
import 'repositories/task_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/message_repository.dart';
import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/messages_viewmodel.dart';

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
    return MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (_) => FirebaseUserRepository(),
        ),
        Provider<TaskRepository>(
          create: (_) => FirebaseTaskRepository(),
        ),
        Provider<MessageRepository>(
          create: (_) => FirebaseMessageRepository(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (context) => HomeViewModel(
            context.read<TaskRepository>(),
            context.read<UserRepository>(),
          ),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (context) => ProfileViewModel(context.read<UserRepository>()),
        ),
        ChangeNotifierProvider<MessagesViewModel>(
          create: (context) => MessagesViewModel(context.read<MessageRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'TaskTap',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFFDE047),
            primary: const Color(0xFFF59E0B),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const MainLayout();
            }
            return const LoginPage();
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const MainLayout(),
        },
      ),
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
