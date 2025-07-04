import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/models/users_model.dart';
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

  //get user for configuration
  Future<List<UsersModel>> getUser(String userId) async {
    final response = await supabase
        .from("USERS")
        .select()
        .eq('uuid', userId);

    return (response as List)
        .map((item) => UsersModel.fromJson(item))
        .toList();
  }

    Future<User?> changePassword(String newPassword) async {
    final response = await supabase.auth.updateUser(
      UserAttributes(password: newPassword),
    );

    return response.user; // só retorna o usuário (ou null se erro)
  }
}
