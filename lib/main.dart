import 'package:flutter/material.dart';
import 'package:mini_taskhub/app/theme.dart';
import 'package:mini_taskhub/auth/auth_service.dart';
import 'package:mini_taskhub/auth/login_screen.dart';
import 'package:mini_taskhub/auth/signup_screen.dart';
import 'package:mini_taskhub/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ygxjrzgxzyysqtrrdcib.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlneGpyemd4enl5c3F0cnJkY2liIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxMjQwOTIsImV4cCI6MjA2MDcwMDA5Mn0.3UjSn9tEg1XyaqKoEbbkWqMTD9tyHUW_kLYjL3sWbd4',
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini TaskHub',
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) {
          final auth = Provider.of<AuthService>(context);
          return auth.currentUserId != null
              ? const DashboardScreen()
              : const LoginScreen();
        },
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}
