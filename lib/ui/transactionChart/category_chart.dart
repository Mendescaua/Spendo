import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendo/components/MonthPicker.dart';
import 'package:spendo/components/transactionContainer.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/utils/customText.dart';

// Você pode importar seu AppTheme com as cores usadas:
import 'package:spendo/utils/theme.dart';

class CategoryChart extends ConsumerStatefulWidget {
  const CategoryChart({super.key});

  @override
  ConsumerState<CategoryChart> createState() =>
      _CategoryChartState();
}

class _CategoryChartState extends ConsumerState<CategoryChart> {
  int? touchedIndex;
  DateTime _selectedMonth = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionControllerProvider);
    final despesas = transactions.where((t) => t.type == 'd').toList();

    // Mapas para valores, cores e tipos por categoria
    final Map<String, double> categoriaGastos = {};
    final Map<String, String> categoriaCores = {};
    final Map<String, String> categoriaTipos = {};

    for (var t in despesas) {
      final categoria = t.category;
      categoriaGastos[categoria] = (categoriaGastos[categoria] ?? 0) + t.value;
      categoriaCores[categoria] = t.categoryColor!;
      categoriaTipos[categoria] = t.categoryType!;
    }

    final total = categoriaGastos.values.fold(0.0, (a, b) => a + b);
    final categorias = categoriaGastos.keys.toList();

    // Categoria selecionada
    final selectedCategory =
        touchedIndex == null ? null : categorias[touchedIndex!];
    final selectedCategoryColor =
        selectedCategory != null ? categoriaCores[selectedCategory]! : null;
    final selectedCategoryType =
        selectedCategory != null ? categoriaTipos[selectedCategory]! : null;

    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: categoriaGastos.isEmpty
            ? const Center(child: Text("Nenhuma despesa encontrada"))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Gastos por categoria",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  MonthPicker(
                    selectedMonth: _selectedMonth,
                    onMonthChanged: (DateTime newMonth) {
                      setState(() => _selectedMonth = newMonth);
                    },
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 80,
                            sections: List.generate(categorias.length, (index) {
                              final categoria = categorias[index];
                              final valor = categoriaGastos[categoria]!;
                              final cor = Customtext.stringToColor(
                                  categoriaCores[categoria]!);
                              final isTouched = index == touchedIndex;

                              return PieChartSectionData(
                                value: valor,
                                title: '',
                                color: touchedIndex == null
                                    ? cor
                                    : isTouched
                                        ? cor
                                        : cor.withOpacity(0.2),
                                radius: 40,
                              );
                            }),
                            pieTouchData: PieTouchData(
                              touchCallback: (event, response) {
                                final index = response
                                        ?.touchedSection?.touchedSectionIndex ??
                                    -1;
                                if (index < 0 || index >= categorias.length) {
                                  setState(() => touchedIndex = null);
                                } else {
                                  setState(() => touchedIndex = index);
                                }
                              },
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              touchedIndex == null
                                  ? "Total"
                                  : categorias[touchedIndex!],
                              style: TextStyle(
                                  color: AppTheme.primaryColor, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Customtext.formatMoeda((touchedIndex == null
                                  ? total
                                  : categoriaGastos[
                                          categorias[touchedIndex!]] ??
                                      0.0)),
                              style: const TextStyle(
                                  color: AppTheme.redColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            if (touchedIndex != null)
                              Text(
                                "${(categoriaGastos[categorias[touchedIndex!]]! / total * 100).toStringAsFixed(1)}%",
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Container que aparece sempre, mostrando total se nada selecionado
                  categoryCard(
                      selectedCategoryType: selectedCategoryType,
                      selectedCategoryColor: selectedCategoryColor,
                      touchedIndex: touchedIndex,
                      categorias: categorias,
                      total: total,
                      categoriaGastos: categoriaGastos),
                ],
              ),
      ),
    );
  }
}

class categoryCard extends StatelessWidget {
  const categoryCard({
    super.key,
    required this.selectedCategoryType,
    required this.selectedCategoryColor,
    required this.touchedIndex,
    required this.categorias,
    required this.total,
    required this.categoriaGastos,
  });

  final String? selectedCategoryType;
  final String? selectedCategoryColor;
  final int? touchedIndex;
  final List<String> categorias;
  final double total;
  final Map<String, double> categoriaGastos;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          TransactionContainer(
            type: selectedCategoryType ?? 'd',
            color: selectedCategoryColor ?? '#FF0000',
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  touchedIndex == null ? "Total" : categorias[touchedIndex!],
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "R\$ ${touchedIndex == null ? total.toStringAsFixed(2) : categoriaGastos[categorias[touchedIndex!]]!.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                touchedIndex == null
                    ? "100%"
                    : "${(categoriaGastos[categorias[touchedIndex!]]! / total * 100).toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
