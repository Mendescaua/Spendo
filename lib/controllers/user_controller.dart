import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/users_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/auth_supabase.dart';

final userControllerProvider =
    StateNotifierProvider<UserController, List<UsersModel>>((ref) {
  return UserController(ref);
});

class UserController extends StateNotifier<List<UsersModel>> {
  final AuthService _authUser = AuthService();
  final Ref ref;

  UserController(this.ref) : super([]);

  Future<String?> getUser() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final transacoes = await _authUser.getUser(userId);
      state = transacoes;
      return null;
    } catch (e) {
      print('Erro ao obter usúario: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> updateUser({String? name, String? picture}) async {
    try {
      final currentUser = state.isNotEmpty ? state.first : null;
      if (currentUser == null) return 'Usuário não carregado';

      final updatedUser = currentUser.copyWith(
        name: name,
        picture: picture,
      );

      await _authUser.updateUserData(user: updatedUser);

      // Atualiza o estado local
      state = [updatedUser];
      return null;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return 'Erro inesperado: $e';
    }
  }

  void clear() {
    state = [];
  }
}
