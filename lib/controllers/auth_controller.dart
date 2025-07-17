import 'package:intl/intl.dart';
import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/services/auth_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return 'Preencha todos os campos.';
    }

    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        return null;
      }
    } on AuthException catch (e) {
      return _traduzirErroSupabase(e.message);
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> register({
    required String email,
    required String password,
    required String name,
    required String confirmPassword,
  }) async {
    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      return 'Preencha todos os campos.';
    }

    if (password != confirmPassword) {
      return 'Senhas diferentes.';
    }

    if (email != email.toLowerCase() ||
        (!email.endsWith(".com") && !email.endsWith(".com.br"))) {
      return 'Insira um email válido!';
    }

    try {
      final user = await _authService.signUp(email, password);

      if (user == null) return "Erro ao cadastrar";

      final dateInc = DateFormat('yyyy-MM-dd').format(DateTime.now());

      await supabase.from('USERS').insert({
        'uuid': user.id,
        'email': user.email,
        'name': name,
        'created_at': dateInc,
      });

      await supabase.from('BANKS').insert({
        'uuid': user.id,
        'name': 'Carteira Digital',
        'type': 'Carteira',
      });

      return null;
    } on AuthException catch (e) {
      return _traduzirErroSupabase(e.message);
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await supabase.auth.signOut();
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
        return null;
      } else {
        return 'Erro ao alterar senha.';
      }
    } on AuthException catch (e) {
      return _traduzirErroSupabase(e.message);
    } catch (e) {
      return 'Erro inesperado: $e';
    }
  }

  // 🔤 Método para traduzir os erros mais comuns
  String _traduzirErroSupabase(String error) {
    final erro = error.toLowerCase();

    if (erro.contains('invalid login credentials')) {
      return 'Email ou senha inválidos.';
    } else if (erro.contains('user already registered')) {
      return 'Usuário já cadastrado.';
    } else if (erro.contains('email not confirmed')) {
      return 'E-mail não confirmado. Verifique sua caixa de entrada.';
    } else if (erro.contains('invalid email or password')) {
      return 'E-mail ou senha inválidos.';
    } else if (erro.contains('password should be at least')) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    } else if (erro.contains('rate limit exceeded')) {
      //coloca o count
      return 'Muitas tentativas. Tente novamente mais tarde.$error';
    }

    return 'Erro: $error';
  }
}
