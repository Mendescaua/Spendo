import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/providers/transactions_provider.dart';
import 'package:spendo/ui/transaction/transaction_screen.dart';
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
            _buildAnimatedCard(
              context,
              type: 'r',
              title: 'Receitas',
              isHidden: widget.isHidden,
            ),
            _buildAnimatedCard(
              context,
              type: 'd',
              title: 'Despesas',
              isHidden: widget.isHidden,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedCard(BuildContext context,
      {required String type,
      required String title,
      required bool isHidden}) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 4,
      closedColor: AppTheme.dynamicCardColor(context),
      openColor: Theme.of(context).scaffoldBackgroundColor,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      transitionDuration: const Duration(milliseconds: 600),
      transitionType: ContainerTransitionType.fade, // alterado
      openBuilder: (context, _) => TransactionScreen(type: type),
      closedBuilder: (context, openContainer) => GestureDetector(
        onTap: openContainer,
        child: Count(
          title: title,
          type: type == 'r' ? 'receita' : 'despesa',
          isHidden: isHidden,
        ),
      ),
    );
  }
}

class Count extends ConsumerWidget {
  final String title;
  final String type;
  final bool isHidden;

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
      if (type == 'receita') {
        return Customtext.formatMoeda(receitas) ?? 'R\$ 0,00';
      }
      return Customtext.formatMoeda(despesas) ?? 'R\$ 0,00';
    }

    Color iconBgColor = type == 'receita'
        ? AppTheme.dynamicReceitaSoftColor(context)
        : AppTheme.dynamicDespesaSoftColor(context);
    Color iconColor = type == 'receita'
        ? AppTheme.dynamicReceitaTotalColor(context)
        : AppTheme.dynamicDespesaTotalColor(context);

    return Container(
      width: size.width * 0.44,
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
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  displayValue(),
                  style: const TextStyle(
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
