import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/MonthPicker2.dart';
import 'package:spendo/components/modals/ModalRelatorioCategories.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/services/relatorios/exportToExcelTransactions.dart';
import 'package:spendo/services/relatorios/exportToPdfTransactions.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class IncomeExpenseBarChart extends ConsumerStatefulWidget {
  const IncomeExpenseBarChart({super.key});

  @override
  ConsumerState<IncomeExpenseBarChart> createState() =>
      _IncomeExpenseBarChartState();
}

class _IncomeExpenseBarChartState extends ConsumerState<IncomeExpenseBarChart> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionControllerProvider);

    // Aqui você pode montar uma lista de meses (ou períodos) para mostrar,
    // por simplicidade, vou considerar apenas o mês selecionado,
    // mas você pode expandir para múltiplos meses.

    // Filtra só o mês selecionado
    final mesAtual = _selectedMonth;

    // Soma receita e despesa do mês selecionado
    final totalReceita = transactions
        .where((t) =>
            t.type == 'r' &&
            t.date.year == mesAtual.year &&
            t.date.month == mesAtual.month)
        .fold<double>(0, (prev, t) => prev + t.value);

    final totalDespesa = transactions
        .where((t) =>
            t.type == 'd' &&
            t.date.year == mesAtual.year &&
            t.date.month == mesAtual.month)
        .fold<double>(0, (prev, t) => prev + t.value);

    // Para exemplo, vamos criar um grupo com receitas e despesas lado a lado
    // Para múltiplos grupos, você criaria uma lista de BarChartGroupData.

    final maxValor =
        (totalReceita > totalDespesa ? totalReceita : totalDespesa) * 1.3;
    final filteredTransactions = transactions
        .where((t) =>
            t.date.month == _selectedMonth.month &&
            t.date.year == _selectedMonth.year)
        .toList();

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transações',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Tooltip(
                message: 'Gerar relatório',
                child: IconButton(
                  icon: Icon(
                    PhosphorIcons.microsoftExcelLogo(
                        PhosphorIconsStyle.regular),
                    color: Color(0xFF217346), // verde Excel
                    size: 28,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => ModalGenerateReport(
                        onGeneratePdf: () {
                          Navigator.pop(context);
                          exportToPdfTransactions(
                            receita: totalReceita,
                            despesa: totalDespesa,
                            transactions: filteredTransactions,
                            nomeArquivo:
                                'relatorio_transacoes_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                          );
                        },
                        onGenerateExcel: () {
                          Navigator.pop(context);
                          exportToExcelTransactions(
                            receita: totalReceita,
                            despesa: totalDespesa,
                            transactions: filteredTransactions,
                            nomeArquivo:
                                'relatorio_transacoes_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Monthpicker2(
            selectedMonth: _selectedMonth,
            onMonthSelected: (mes) {
              setState(() {
                _selectedMonth = mes!;
              });
            },
            textColor: AppTheme.dynamicTextColor(context),
          ),
          const SizedBox(height: 24),
          if (totalReceita == 0 && totalDespesa == 0)
            const Expanded(
              child: Center(
                child: Text(
                  'Nenhuma transação encontrada.',
                ),
              ),
            )
          else
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: maxValor,
                  groupsSpace:
                      44, // espaçamento entre grupos (no seu caso só 1 grupo)
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barsSpace: 20,
                      barRods: [
                        BarChartRodData(
                          toY: totalReceita,
                          color:
                              AppTheme.greenColor, // azul forte, como na imagem
                          width: 32,
                          borderRadius: BorderRadius.circular(6),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxValor,
                            color: AppTheme.softGreenColor,
                          ),
                        ),
                        BarChartRodData(
                          toY: totalDespesa,
                          color: AppTheme.dynamicRedColor(
                              context), // laranja forte
                          width: 32,
                          borderRadius: BorderRadius.circular(6),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: maxValor,
                            color: AppTheme.softRedColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxValor / 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.15),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 60,
                        interval: maxValor / 5,
                        getTitlesWidget: (value, meta) {
                          // Exemplo: mostrar em formato B (bilhões) ou M (milhões)
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              _formatLargeValue(value),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final label = rodIndex == 0 ? 'Receita' : 'Despesa';
                        return BarTooltipItem(
                          '$label\n${Customtext.formatMoeda(rod.toY)}',
                          const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Função para formatar valores grandes tipo 100B, 50M etc
  String _formatLargeValue(double value) {
    if (value >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(0)}B';
    } else if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(0)}M';
    } else if (value >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}
