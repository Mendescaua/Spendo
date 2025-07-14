import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final savingControllerProvider =
    StateNotifierProvider<SavingController, List<SavingModel>>((ref) {
  return SavingController(ref);
});

class SavingController extends StateNotifier<List<SavingModel>> {
  final SupabaseService _saving = SupabaseService();
  final Ref ref;

  SavingController(this.ref) : super([]);

  Future<String?> getSaving() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
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

  Future<String?> addSaving({required SavingModel saving}) async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (saving.title!.isEmpty) return 'Adicione um título.';
    if (saving.goalValue! <= 0) return 'Adicione um valor de meta.';
    if (saving.picture!.isEmpty) return 'Adicione uma imagem de meta.';

    try {
      final newSaving = await _saving.addSaving(SavingModel(
        uuid: userId,
        title: saving.title,
        goalValue: saving.goalValue,
        picture: saving.picture,
      ));

      state = [...state, newSaving]; // agora newSaving TEM id e value
      return null;
    } catch (e) {
      print('Erro ao adicionar cofrinho: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> updateSavingValue(
      {required SavingModel saving, required String type}) async {
    if (saving.id == null || saving.value == null) {
      return 'ID e valor do cofrinho são obrigatórios para atualizar';
    }

    try {
      // Pega o valor atual do cofrinho no estado local
      final current = state.firstWhere((item) => item.id == saving.id);
      final newValue;

      if (type == 'retirar') {
        if (saving.value! > (current.value ?? 0)) {
          return 'Você não pode retirar um valor maior que o acumulado.';
        }
        newValue = (current.value ?? 0) - saving.value!;
      } else {
        if ((current.value ?? 0) + saving.value! > (current.goalValue ?? 0)) {
          return 'Você não pode adicionar um valor que ultrapasse a meta.';
        }
        newValue = (current.value ?? 0) + saving.value!;
      }

      // Atualiza no banco
      await _saving.updateSavingValue(id: saving.id!, value: newValue);

      // Atualiza no estado local
      state = state.map((item) {
        if (item.id == saving.id) {
          return item.copyWith(value: newValue);
        }
        return item;
      }).toList();

      return null;
    } catch (e) {
      print('Erro ao atualizar cofrinho: $e');
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
