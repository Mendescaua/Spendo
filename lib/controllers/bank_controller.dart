import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/bank_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final bankControllerProvider =
    StateNotifierProvider<BankController, List<BanksModel>>(
        (ref) {
  return BankController(ref);
});

class BankController extends StateNotifier<List<BanksModel>> {
  final SupabaseService _banks = SupabaseService();
  final Ref ref;

  BankController(this.ref) : super([]);

  Future<String?> getBank() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final banks = await _banks.getBanks(userId);
      state = banks;
      return null;
    } catch (e) {
      print('Erro ao obter contas bancárias: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> addBank({required BanksModel bank}) async {
  final userId = ref.read(currentUserId);
  if (userId == null) return 'Usuário não autenticado';

  if (bank.name == "") return 'Selecione uma conta';
  if (bank.type == "") return 'Selecione o tipo da conta';

  // Verifica se já existe uma conta com o mesmo nome
  final alreadyExists = state.any((item) =>
      item.uuid == userId &&
      item.name.toLowerCase() == bank.name.toLowerCase());

  if (alreadyExists) {
    return 'Você já adicionou essa conta.';
  }

  try {
    final newBanks = BanksModel(
      uuid: userId,
      name: bank.name,
      type: bank.type,
    );
    await _banks.addBanks(newBanks);

    state = [...state, newBanks];
    return null;
  } catch (e) {
    print('Erro ao adicionar conta bancária: $e');
    return 'Erro inesperado: $e';
  }
}


  Future<String?> deleteBank({required int id}) async {
  try {
    await _banks.deleteBanks(id);

    // Remove do estado
    state = state.where((item) => item.id != id).toList();

    return null;
  } catch (e) {
    print('Erro ao deletar assinatura: $e');
    return 'Erro inesperado: $e';
  }
}

  void clear() {
    state = [];
  }
}
