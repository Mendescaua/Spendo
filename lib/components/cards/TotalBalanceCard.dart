import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/providers/transactions_provider.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class SaldoGeralCard extends ConsumerStatefulWidget {
  const SaldoGeralCard({super.key});

  @override
  ConsumerState<SaldoGeralCard> createState() => _SaldoGeralCardState();
}

class _SaldoGeralCardState extends ConsumerState<SaldoGeralCard> {
  bool _isHidden = false; // controle do estado de ocultar/mostrar

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(totalGeralProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo geral',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.whiteColor,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isHidden
                    ? '*********'
                    : (Customtext.formatMoeda(total) ?? 'R\$ 0,00'),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.whiteColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isHidden = !_isHidden;
                  });
                },
                icon: Icon(_isHidden ? Iconsax.eye : Iconsax.eye_slash),
                color: AppTheme.whiteColor,
              )
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/transactions_receita'),
                child: Count(
                  title: 'Receitas',
                  type: 'receita',
                  isHidden: _isHidden, // passa para o Count
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/transactions_despesa'),
                child: Count(
                  title: 'Despesas',
                  type: 'despesa',
                  isHidden: _isHidden, // passa para o Count
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
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
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: size.width * 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.whiteColor,
                  ),
                ),
                const SizedBox(height: 4),
                AutoSizeText(
                  displayValue(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.whiteColor,
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
