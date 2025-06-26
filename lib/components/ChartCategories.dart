import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spendo/controllers/transaction_controller.dart';

class CategoriaDonutChart extends ConsumerStatefulWidget {
  const CategoriaDonutChart({super.key});

  @override
  ConsumerState<CategoriaDonutChart> createState() =>
      _CategoriaDonutChartState();
}

class _CategoriaDonutChartState extends ConsumerState<CategoriaDonutChart> {
  int? touchedIndex;

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionControllerProvider);
    final despesas = transactions.where((t) => t.type == 'd').toList();

    final Map<String, double> categoriaGastos = {};
    final Map<String, String> categoriaCores = {};
    for (var t in despesas) {
      final categoria = t.category;
      categoriaGastos[categoria] = (categoriaGastos[categoria] ?? 0) + t.value;
      categoriaCores[categoria] = t.categoryColor!;
    }

    final total = categoriaGastos.values.fold(0.0, (a, b) => a + b);
    final categorias = categoriaGastos.keys.toList();

    return categoriaGastos.isEmpty
        ? const Center(child: Text("Nenhuma despesa encontrada"))
        : Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text(
                      "Despesas por ",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Categoria",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      "Ver mais",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline),
                    ),
                    Icon(Icons.chevron_right),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 40, // menor espaço central → mais grosso
                          sections: List.generate(categorias.length, (index) {
                            final categoria = categorias[index];
                            final valor = categoriaGastos[categoria]!;
                            final percent = (valor / total * 100);
                            final cor = hexToColor(categoriaCores[categoria]!);
                            final isTouched = index == touchedIndex;

                            return PieChartSectionData(
                              value: valor,
                              title: '',
                              color: touchedIndex == null
                                  ? cor
                                  : isTouched
                                      ? cor
                                      : cor.withOpacity(0.2),
                              radius: 60, // aumentamos para engrossar o anel
                            );
                          }),
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              if (response == null ||
                                  response.touchedSection == null) {
                                setState(() {
                                  touchedIndex = null; // clicou fora → desfoca
                                });
                              } else {
                                setState(() {
                                  touchedIndex = response
                                      .touchedSection!.touchedSectionIndex;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      if (touchedIndex != null)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              categorias[touchedIndex!],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${(categoriaGastos[categorias[touchedIndex!]]! / total * 100).toStringAsFixed(1)}%",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "R\$ ${categoriaGastos[categorias[touchedIndex!]]!.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: categorias.map((categoria) {
                    final valor = categoriaGastos[categoria]!;
                    final percent = (valor / total * 100);
                    final cor = hexToColor(categoriaCores[categoria]!);
                    return ListTile(
                      leading: CircleAvatar(backgroundColor: cor, radius: 10),
                      title: Text(categoria),
                      trailing: Text(
                          "R\$ ${valor.toStringAsFixed(2)} (${percent.toStringAsFixed(1)}%)"),
                    );
                  }).toList(),
                )
              ],
            ),
          );
  }
}
