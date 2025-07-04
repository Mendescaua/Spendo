import 'package:intl/intl.dart';
import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/services/auth_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<String?> login(
      {required String email, required String password}) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Preencha todos os campos.';
    }
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        return null;
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> register(
      {required String email,
      required String password,
      required String name}) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return 'Preencha todos os campos.';
    }

    if (email != email.toLowerCase() || !email.endsWith(".com")) {
      return 'Insira um email válido';
    }

    try {
      final user = await _authService.signUp(
        email,
        password,
      );

      if (user == null) return "Erro ao cadastrar";

      final dateInc = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await supabase.from('USERS').insert({
        'uuid': user.id,
        'email': user.email,
        'name': name,
        'created_at': dateInc,
      });

      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<void> signOut() async {
  try {
    await supabase.auth.signOut();

    // Garante que a sessão foi realmente encerrada e limpa do cache local
    await supabase.auth.refreshSession(); // opcional

    print('Logout concluído com sucesso');
  } catch (e) {
    print('Erro ao deslogar: $e');
  }
}

Future<String?> changePassword(String password) async {
    if (password.isEmpty) return 'Informe a nova senha';
    if (password.length < 6) return 'A senha deve ter ao menos 6 caracteres';

    try {
      final user = await _authService.changePassword(password);

      if (user != null) {
        return null; // sucesso
      } else {
        return 'Erro ao alterar senha.';
      }
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

}
