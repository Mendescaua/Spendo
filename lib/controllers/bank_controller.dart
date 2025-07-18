import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendo/models/bank_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final bankControllerProvider =
    StateNotifierProvider<BankController, List<BanksModel>>((ref) {
  return BankController(ref);
});

class BankController extends StateNotifier<List<BanksModel>> {
  final SupabaseService _banks = SupabaseService();
  final Ref ref;

  BankController(this.ref) : super([]);

  // Método para carregar bancos e aplicar ordem salva localmente
  Future<String?> getBank() async {
    String? userId;
    int tentativas = 0;

    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final banks = await _banks.getBanks(userId);

      // Pega ordem salva localmente
      final prefs = await SharedPreferences.getInstance();
      final savedOrder = prefs.getStringList('bank_order');

      if (savedOrder != null && savedOrder.isNotEmpty) {
        banks.sort((a, b) {
          final indexA = savedOrder.indexOf(a.id.toString());
          final indexB = savedOrder.indexOf(b.id.toString());
          if (indexA == -1) return 1;
          if (indexB == -1) return -1;
          return indexA.compareTo(indexB);
        });
      }

      state = banks;
      return null;
    } catch (e) {
      print('Erro ao obter contas bancárias: $e');
      return 'Erro inesperado: $e';
    }
  }

  // Novo método para atualizar ordem, salvar local e atualizar estado
  Future<void> updateOrder(List<BanksModel> newOrder) async {
    state = newOrder;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'bank_order',
      newOrder.map((b) => b.id.toString()).toList(),
    );
  }

  Future<Map<String, dynamic>?> getBankInfo({
  required String bankName,
  DateTime? date, // parâmetro opcional para filtro por data
}) async {
  String? userId;
  int tentativas = 0;

  while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
    await Future.delayed(const Duration(milliseconds: 100));
    tentativas++;
  }

  if (userId == null) return null;

  try {
    final info = await _banks.getBankInfo(
      userId: userId,
      bankName: bankName,
      date: date, // repassando a data opcional
    );
    return info;
  } catch (e) {
    print('Erro ao obter informações da conta bancária: $e');
    return null;
  }
}


  Future<String?> addBank({required BanksModel bank}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (bank.name == "") return 'Selecione uma conta';
    if (bank.type == "") return 'Selecione o tipo da conta';

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
