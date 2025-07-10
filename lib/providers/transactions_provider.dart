import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/controllers/transaction_controller.dart';

/// Verifica se a data pertence ao mês e ano atual
bool isCurrentMonth(DateTime date) {
  final now = DateTime.now();
  return date.month == now.month && date.year == now.year;
}

/// Provider que calcula o saldo geral do mês atual
final totalGeralProvider = Provider<double>((ref) {
  final transacoes = ref.watch(transactionControllerProvider);

  double totalDespesas = 0.0;
  double totalReceitas = 0.0;

  for (final t in transacoes) {
    if (!isCurrentMonth(t.date)) continue;

    if (t.type == 'r') {
      totalReceitas += t.value;
    } else if (t.type == 'd') {
      totalDespesas += t.value;
    }
  }

  return totalReceitas - totalDespesas;
});

/// Provider que calcula o total de despesas do mês atual
final totalDespesasProvider = Provider<double>((ref) {
  final transacoes = ref.watch(transactionControllerProvider);
  return transacoes
      .where((t) => t.type == 'd' && isCurrentMonth(t.date))
      .fold(0.0, (soma, t) => soma + t.value);
});

/// Provider que calcula o total de receitas do mês atual
final totalReceitasProvider = Provider<double>((ref) {
  final transacoes = ref.watch(transactionControllerProvider);
  return transacoes
      .where((t) => t.type == 'r' && isCurrentMonth(t.date))
      .fold(0.0, (soma, t) => soma + t.value);
});
