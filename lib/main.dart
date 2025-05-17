import 'package:flutter/material.dart';
import 'package:spendo/ui/login_screen.dart';
import 'package:spendo/ui/register_screen.dart';
import 'package:spendo/ui/splash_screen.dart';
import 'package:spendo/utils/theme.dart';

void main() {
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
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        // Add other routes here
      },
    );
  }
}
