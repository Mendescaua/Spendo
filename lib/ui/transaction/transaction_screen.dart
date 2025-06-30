import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/providers/transactions_provider.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionScreen extends ConsumerWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionControllerProvider);
    final despesas = ref.watch(totalDespesasProvider);
    final receitas = ref.watch(totalReceitasProvider);

    final transacoesAgrupadas = _agruparPorData(transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minhas transações",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Total de despesas",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  Customtext.formatMoeda(despesas),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.whiteColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: transacoesAgrupadas.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 32),
                        child: Text(
                          "Nenhuma transação encontrada",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: transacoesAgrupadas.entries.map((entry) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...entry.value.map((transacao) =>
                                  TransactionCard(transaction: transacao)),
                              const SizedBox(height: 24),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Agrupa as transações por data (ex: "Segunda, 10")
  Map<String, List<TransactionModel>> _agruparPorData(
      List<TransactionModel> transacoes) {
    final Map<String, List<TransactionModel>> agrupadas = {};

    for (var transacao in transacoes) {
      final data = transacao.date; // DateTime
      final nomeDia = _diaSemana(data.weekday); // Segunda, Terça...
      final dia = data.day.toString().padLeft(2, '0');
      final chave = "$nomeDia, $dia";

      if (agrupadas.containsKey(chave)) {
        agrupadas[chave]!.add(transacao);
      } else {
        agrupadas[chave] = [transacao];
      }
    }

    return agrupadas;
  }

  /// Converte int do weekday (1-7) para nome do dia
  String _diaSemana(int weekday) {
    const dias = [
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];
    return dias[(weekday - 1) % 7];
  }
}
