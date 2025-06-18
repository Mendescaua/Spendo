import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final savingControllerProvider =
    StateNotifierProvider<SavingController, List<SavingModel>>(
        (ref) {
  return SavingController(ref);
});

class SavingController extends StateNotifier<List<SavingModel>> {
  final SupabaseService _saving = SupabaseService();
  final Ref ref;

  SavingController(this.ref) : super([]);

  Future<String?> getSaving() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 5 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 5) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final saving = await _saving.getSaving(userId);
      state = saving;
      return null;
    } catch (e) {
      print('Erro ao obter cofrinhos: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> addSaving(
      {required SavingModel subscription}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (subscription.title.isEmpty) return 'Adicione um título.';
    if (subscription.value <= 0) return 'Adicione um valor.';

    try {
      final newSaving = SavingModel(
        title: subscription.title,
        value: subscription.value,
        goalValue: subscription.goalValue,
        colorCard: subscription.colorCard,
      );
      await _saving.addSaving(newSaving);
      state = [...state, newSaving];
      return null;
    } catch (e) {
      print('Erro ao adicionar cofrinho: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> deleteSaving({required int id}) async {
  try {
    await _saving.deleteSaving(id);

    // Remove do estado
    state = state.where((item) => item.id != id).toList();

    return null;
  } catch (e) {
    print('Erro ao deletar cofrinho: $e');
    return 'Erro inesperado: $e';
  }
}

  void clear() {
    state = [];
  }
}
