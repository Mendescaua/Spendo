import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/controllers/transaction_controller.dart';

final totalGeralProvider = Provider<double>((ref) {
  final transacoes = ref.watch(transactionControllerProvider);

  double totalDespesas = 0.0;
  double totalReceitas = 0.0;

  for (final t in transacoes) {
    print('Transação: type=${t.type}, value=${t.value}');
    if (t.type == 'r') {
      totalReceitas += t.value;
    } else if (t.type == 'd') {
      totalDespesas += t.value;
    }
  }

  print('totalReceitas: $totalReceitas, totalDespesas: $totalDespesas');

  if (totalReceitas > 0 && totalDespesas > 0) {
    return totalReceitas - totalDespesas;
  } else if (totalReceitas > 0) {
    return totalReceitas;
  } else if (totalDespesas > 0) {
    return -totalDespesas;
  } else {
    return 0.0;
  }
});

final totalDespesasProvider = Provider<double>((ref) {
  final transacoes = ref.watch(transactionControllerProvider);
  return transacoes
      .where((t) => t.type == 'd')
      .fold(0.0, (soma, t) => soma + t.value);
});

final totalReceitasProvider = Provider<double>((ref) {
  final transacoes = ref.watch(transactionControllerProvider);
  return transacoes
      .where((t) => t.type == 'r')
      .fold(0.0, (soma, t) => soma + t.value);
});
