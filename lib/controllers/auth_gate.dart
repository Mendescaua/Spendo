import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/ui/splash_screen.dart';
import 'package:spendo/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading...
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppTheme.whiteColor, size: 60),
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
