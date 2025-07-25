import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/providers/transactions_provider.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class SaldoGeralCard extends ConsumerStatefulWidget {
  final bool isHidden;
  const SaldoGeralCard({super.key, required this.isHidden});

  @override
  ConsumerState<SaldoGeralCard> createState() => _SaldoGeralCardState();
}

class _SaldoGeralCardState extends ConsumerState<SaldoGeralCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, '/transactions_receita'),
              child: Count(
                title: 'Receitas',
                type: 'receita',
                isHidden: widget.isHidden,
              ),
            ),
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, '/transactions_despesa'),
              child: Count(
                title: 'Despesas',
                type: 'despesa',
                isHidden: widget.isHidden,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class Count extends ConsumerWidget {
  final String title;
  final String type;
  final bool isHidden; // novo parâmetro para controlar ocultar números

  const Count({
    super.key,
    required this.title,
    required this.type,
    this.isHidden = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final despesas = ref.watch(totalDespesasProvider);
    final receitas = ref.watch(totalReceitasProvider);
    Size size = MediaQuery.of(context).size;

    String displayValue() {
      if (isHidden) return '*******';
      if (type == 'receita')
        return Customtext.formatMoeda(receitas) ?? 'R\$ 0,00';
      return Customtext.formatMoeda(despesas) ?? 'R\$ 0,00';
    }

    Color iconBgColor =
        type == 'receita' ? AppTheme.softGreenColor : AppTheme.softRedColor;
    Color iconColor =
        type == 'receita' ? AppTheme.greenColor : AppTheme.redColor;

    return Container(
      width: size.width * 0.42,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Iconsax.money,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  displayValue(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  stepGranularity: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
