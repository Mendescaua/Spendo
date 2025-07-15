import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/MonthPicker2.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionBankScreen extends ConsumerStatefulWidget {
  final String bankName;
  final String type; // 'r' ou 'd'

  const TransactionBankScreen({
    super.key,
    required this.bankName,
    required this.type,
  });

  @override
  ConsumerState<TransactionBankScreen> createState() => _TransactionBankScreenState();
}

class _TransactionBankScreenState extends ConsumerState<TransactionBankScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionControllerProvider);

    // Filtra as transações pelo banco, tipo e mês selecionado
    var transactionsFiltradas = transactions.where((t) {
      return t.bank == widget.bankName &&
          t.type == widget.type &&
          t.date.year == _selectedMonth.year &&
          t.date.month == _selectedMonth.month;
    }).toList();

    final totalValue = transactionsFiltradas.fold(0.0, (sum, t) => sum + t.value);

    final transacoesAgrupadas = _agruparPorData(transactionsFiltradas);

    final datasOrdenadas = transacoesAgrupadas.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    String _tituloPorTipo(String tipo) {
      switch (tipo) {
        case 'r':
          return 'Receitas de ${widget.bankName}';
        case 'd':
          return 'Despesas de ${widget.bankName}';
        default:
          return 'Transações de ${widget.bankName}';
      }
    }

    String _tituloTotal(String tipo) {
      switch (tipo) {
        case 'r':
          return 'Total de receitas';
        case 'd':
          return 'Total de despesas';
        default:
          return 'Saldo total';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloPorTipo(widget.type),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _tituloTotal(widget.type),
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  Customtext.formatMoeda(totalValue),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.whiteColor,
                  ),
                ),
                const SizedBox(height: 16),
                Monthpicker2(
                  selectedMonth: _selectedMonth,
                  onMonthSelected: (mes) {
                    setState(() {
                      _selectedMonth = mes!;
                    });
                  },
                  textColor: AppTheme.whiteColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: datasOrdenadas.isEmpty
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
                        children: datasOrdenadas.map((data) {
                          final transacoesDoDia = transacoesAgrupadas[data]!;
                          final nomeDia = _diaSemana(data.weekday);
                          final dia = data.day.toString().padLeft(2, '0');
                          final nomeMes = _nomeMes(data.month);
                          final titulo = "$nomeDia, $dia de $nomeMes";

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...transacoesDoDia
                                  .map((transacao) =>
                                      TransactionCard(transaction: transacao))
                                  .toList(),
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

  Map<DateTime, List<TransactionModel>> _agruparPorData(
      List<TransactionModel> transacoes) {
    final Map<DateTime, List<TransactionModel>> agrupadas = {};

    for (var transacao in transacoes) {
      final data = DateTime(
        transacao.date.year,
        transacao.date.month,
        transacao.date.day,
      );
      if (agrupadas.containsKey(data)) {
        agrupadas[data]!.add(transacao);
      } else {
        agrupadas[data] = [transacao];
      }
    }

    return agrupadas;
  }

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

  String _nomeMes(int month) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    return meses[month - 1];
  }
}
