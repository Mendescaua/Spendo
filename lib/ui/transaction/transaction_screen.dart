import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/providers/transactions_provider.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

final filtroTransacaoProvider = StateProvider<String>((ref) => 'all');

class TransactionScreen extends ConsumerStatefulWidget {
  final String? type;
  const TransactionScreen({super.key, this.type});

  @override
  ConsumerState<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {
  DateTime? _selectedMonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filtroTransacaoProvider.notifier).state = widget.type ?? 'all';
    });
  }

  Future<void> _selectMonth(BuildContext context) async {
    final selected = await showMonthPicker(
      context: context,
      initialDate: _selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (selected != null) {
      setState(() {
        _selectedMonth = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtro = ref.watch(filtroTransacaoProvider);
    final transactions = ref.watch(transactionControllerProvider);

    // Filtra as transações conforme filtro selecionado
    var transactionsFiltradas = filtro == 'all'
        ? transactions
        : transactions.where((t) => t.type == filtro).toList();

    // Filtra as transações conforme mês selecionado, se houver
    if (_selectedMonth != null) {
      transactionsFiltradas = transactionsFiltradas.where((t) {
        return t.date.year == _selectedMonth!.year &&
            t.date.month == _selectedMonth!.month;
      }).toList();
    }

    final despesas = ref.watch(totalDespesasProvider);
    final receitas = ref.watch(totalReceitasProvider);

    final transacoesAgrupadas = _agruparPorData(transactionsFiltradas);

    final datasOrdenadas = transacoesAgrupadas.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    String _tituloPorFiltro(String filtro) {
      switch (filtro) {
        case 'r':
          return 'Minhas receitas';
        case 'd':
          return 'Minhas despesas';
        case 'all':
        default:
          return 'Minhas transações';
      }
    }

    String _tituloTotal(String filtro) {
      switch (filtro) {
        case 'r':
          return 'Total de receitas';
        case 'd':
          return 'Total de despesas';
        case 'all':
        default:
          return 'Saldo total';
      }
    }

    double _valorTotal(String filtro, double receitas, double despesas) {
      switch (filtro) {
        case 'r':
          return receitas;
        case 'd':
          return despesas;
        case 'all':
        default:
          return receitas - despesas;
      }
    }

    String _formatMesAno(DateTime? date) {
      if (date == null) return "Todos os meses";
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
      return "${meses[date.month - 1]} de ${date.year}";
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 30),
            Text(
              _tituloPorFiltro(filtro),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              initialValue: filtro,
              icon: Icon(
                PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
                color: AppTheme.whiteColor,
              ),
              onSelected: (value) {
                ref.read(filtroTransacaoProvider.notifier).state = value;
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'all',
                  child: Text('Transações'),
                ),
                PopupMenuItem(
                  value: 'r',
                  child: Text('Receitas'),
                ),
                PopupMenuItem(
                  value: 'd',
                  child: Text('Despesas'),
                ),
              ],
            ),
          ],
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
                Text(
                  _tituloTotal(filtro),
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  Customtext.formatMoeda(_valorTotal(filtro, receitas, despesas)),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.whiteColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Campo para selecionar mês
                GestureDetector(
                  onTap: () => _selectMonth(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white24,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatMesAno(_selectedMonth),
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
                          color: Colors.white,
                        )
                      ],
                    ),
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
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
