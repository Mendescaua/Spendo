import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/subscription_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final subscriptionControllerProvider =
    StateNotifierProvider<SubscriptionController, List<SubscriptionModel>>(
        (ref) {
  return SubscriptionController(ref);
});

class SubscriptionController extends StateNotifier<List<SubscriptionModel>> {
  final SupabaseService _subscription = SupabaseService();
  final Ref ref;

  SubscriptionController(this.ref) : super([]);

  Future<String?> getSubscription() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final subscriptions = await _subscription.getSubscription(userId);
      state = subscriptions;
      return null;
    } catch (e) {
      print('Erro ao obter assinaturas: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> addSubscription(
      {required SubscriptionModel subscription}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (subscription.name.isEmpty) return 'Adicione um título.';
    if (subscription.value <= 0) return 'Adicione um valor.';

    try {
      final newSubscription = SubscriptionModel(
          uuid: userId,
          name: subscription.name,
          description: subscription.description,
          value: subscription.value,
          time: subscription.time,);
      await _subscription.addSubscription(newSubscription);
      // Atualiza o estado com a nova transação adicionada
      state = [...state, newSubscription];
      return null;
    } catch (e) {
      print('Erro ao adicionar assinatura: $e');
      return 'Erro inesperado: $e';
    }
  }

  void clear() {
    state = [];
  }
}
