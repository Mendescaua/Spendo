import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/money_card_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final moneyCardControllerProvider =
    StateNotifierProvider<MoneyCardController, List<MoneyCardModel>>((ref) {
  return MoneyCardController(ref);
});

class MoneyCardController extends StateNotifier<List<MoneyCardModel>> {
  final SupabaseService _moneyCard = SupabaseService();
  final Ref ref;

  MoneyCardController(this.ref) : super([]);

  Future<String?> getMoneyCard() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final moneyCard = await _moneyCard.getMoneyCard(userId);
      state = moneyCard;
      return null;
    } catch (e) {
      print('Erro ao obter cartão: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> addMoneyCard({required MoneyCardModel moneyCard}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (moneyCard.number < 4) return 'Adicione os últimos 4 dígitos do cartão.';
    if (moneyCard.name.isEmpty) return 'Adicione um banco.';
    if (moneyCard.validity == null) return 'Adicione a data de validade.';
    if (moneyCard.flag.isEmpty) return 'Adicione a bandeira.';

    try {
      final newMoneyCard = MoneyCardModel(
        uuid: userId,
        name: moneyCard.name,
        number: moneyCard.number,
        flag: moneyCard.flag,
        validity: moneyCard.validity,
      );
      await _moneyCard.addMoneyCard(newMoneyCard);
      // Atualiza o estado com a nova transação adicionada
      state = [...state, newMoneyCard];
      return null;
    } catch (e) {
      print('Erro ao adicionar cartão: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> deleteMoneyCard({required int id}) async {
  try {
    await _moneyCard.deleteMoneyCard(id);

    // Remove do estado
    state = state.where((item) => item.id != id).toList();

    return null;
  } catch (e) {
    print('Erro ao deletar cartão: $e');
    return 'Erro inesperado: $e';
  }
}

Future<String?> updateCardOrder(int id, int newOrder) async {
    try {
      await _moneyCard.updateCardOrder(id, newOrder);

      final idx = state.indexWhere((card) => card.id == id);
      if (idx != -1) {
        final updatedCard = MoneyCardModel(
          id: state[idx].id,
          uuid: state[idx].uuid,
          number: state[idx].number,
          name: state[idx].name,
          flag: state[idx].flag,
          validity: state[idx].validity,
          createdAt: state[idx].createdAt,
          order: newOrder,
        );
        final newState = [...state];
        newState[idx] = updatedCard;
        state = newState;
      }
    } catch (e) {
       print('Erro ao atualizar cartão: $e');
      return 'Erro inesperado: $e';
    }
  }

  void clear() {
    state = [];
  }
}
