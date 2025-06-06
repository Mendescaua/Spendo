import 'package:flutter/material.dart';
import 'package:spendo/controllers/auth_gate.dart';
import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/ui/home_screen.dart';
import 'package:spendo/ui/auth/login_screen.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/ui/auth/register_screen.dart';
import 'package:spendo/ui/splash_screen.dart';
import 'package:spendo/utils/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initSupabase();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendo',
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/menu': (context) => const MainScreen(),
        
      },
    );
  }
}
