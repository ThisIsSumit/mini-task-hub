import 'package:flutter/material.dart';
import 'package:mini_taskhub/app/theme.dart';
import 'package:mini_taskhub/auth/auth_service.dart';
import 'package:mini_taskhub/auth/login_screen.dart';
import 'package:mini_taskhub/auth/signup_screen.dart';
import 'package:mini_taskhub/dashboard/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
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
