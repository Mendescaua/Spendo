import 'package:flutter/material.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/ui/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Verifica se há uma sessão ativa a partir dos dados do snapshot.
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return MainScreen();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}