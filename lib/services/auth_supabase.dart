import 'package:spendo/core/supabse_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Login
  Future<User?> signIn(String email, String password) async {
    final response = await supabase.auth
        .signInWithPassword(email: email, password: password);

    return response.user;
  }

  // Cadastro
  Future<User?> signUp(
    String email,
    String password,
  ) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response.user;
  }

  // Logout
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // Email do usuário atual
  String? getCurrentUserEmail() {
    return supabase.auth.currentUser?.email;
  }
}
