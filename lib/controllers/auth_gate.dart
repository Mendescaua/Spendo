import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/ui/splash_screen.dart';
import 'package:spendo/utils/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGate extends StatefulWidget {
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _autenticado = false;
  bool _tentandoAutenticar = false;

  Future<bool> _verificarBiometria() async {
    final prefs = await SharedPreferences.getInstance();
    final biometriaAtivada = prefs.getBool('autenticacao_ativada') ?? false;

    if (!biometriaAtivada) return true; // biometria não ativada, libera direto

    final auth = LocalAuthentication();
    final podeAutenticar =
        await auth.canCheckBiometrics || await auth.isDeviceSupported();

    if (!podeAutenticar) return true; // não suporta, libera direto

    try {
      final autenticado = await auth.authenticate(
        localizedReason: 'Autentique-se para continuar',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
      return autenticado;
    } catch (e) {
      return false;
    }
  }

  Widget telaEsperandoBiometria() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
                color: AppTheme.primaryColor, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Aguardando autenticação biométrica...',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: AppTheme.primaryColor, size: 100),
            ),
          );
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          if (!_autenticado && !_tentandoAutenticar) {
            _tentandoAutenticar = true;
            _verificarBiometria().then((success) {
              if (!success) {
                Supabase.instance.client.auth.signOut();
              }
              setState(() {
                _autenticado = success;
                _tentandoAutenticar = false;
              });
            });
          }
          if (_tentandoAutenticar) {
            return telaEsperandoBiometria();
          }
          if (_autenticado) {
            return MainScreen();
          } else {
            // Não autenticou, mostra splash (ou pode mostrar erro)
            return SplashScreen();
          }
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
