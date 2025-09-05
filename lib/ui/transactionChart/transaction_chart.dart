import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/MonthPicker2.dart';
import 'package:spendo/components/modals/ModalRelatorioCategories.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/services/relatorios/exportToExcelTransactions.dart';
import 'package:spendo/services/relatorios/exportToPdfTransactions.dart';
import 'package:spendo/utils/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

    final filteredTransactions = transactions
        .where((t) =>
            t.date.month == _selectedMonth.month &&
            t.date.year == _selectedMonth.year)
        .toList();

    final totalReceita = filteredTransactions
        .where((t) => t.type == 'r')
        .fold<double>(0, (prev, t) => prev + t.value);

    final totalDespesa = filteredTransactions
        .where((t) => t.type == 'd')
        .fold<double>(0, (prev, t) => prev + t.value);

    final List<_ChartData> chartData = [
      _ChartData(
          'Receita', totalReceita, AppTheme.dynamicReceitaColor(context)),
      _ChartData('Despesa', totalDespesa, AppTheme.dynamicRedColor(context)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Transações',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Tooltip(
              message: 'Gerar relatório',
              child: IconButton(
                icon: Icon(
                  PhosphorIcons.microsoftExcelLogo(PhosphorIconsStyle.regular),
                  color: Color(0xFF217346),
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
        Expanded(
          child: chartData.every((d) => d.valor == 0)
              ? const Center(
                  child: Text(
                  'Nenhuma transação encontrada.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ))
              : SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_ChartData, String>>[
                    ColumnSeries<_ChartData, String>(
                      dataSource: chartData,
                      xValueMapper: (data, _) => data.titulo,
                      yValueMapper: (data, _) => data.valor,
                      pointColorMapper: (data, _) => data.cor,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                      borderRadius: BorderRadius.circular(10),
                    )
                  ],
                  plotAreaBorderWidth: 0,
                ),
        ),
      ],
    );
  }
}

class _ChartData {
  final String titulo;
  final double valor;
  final Color cor;

  _ChartData(this.titulo, this.valor, this.cor);
}
