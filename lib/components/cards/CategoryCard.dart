import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/transactionContainer.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class CategoryCard extends ConsumerWidget {
  final CategoryTransactionModel category;
  final Function(bool isArchived)? onArquivar;
  final Function()? onEditar;
  final bool? tipo; // true para arquivar, false para desarquivar

  const CategoryCard({
    Key? key,
    required this.category,
    this.onArquivar,
    this.onEditar,
    this.tipo,
  }) : super(key: key);

 void _showActionSheet(BuildContext context) {
  final size = MediaQuery.of(context).size;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: false,
    builder: (_) {
      return SafeArea(
        child: Container(
          height: size.height * 0.35,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          decoration: BoxDecoration(
            color: AppTheme.dynamicModalColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'O que deseja fazer?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.dynamicTextColor(context),
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionButton(
                context: context,
                label: tipo == true ? 'Arquivar categoria' : 'Desarquivar categoria',
                icon: tipo == true
                    ? PhosphorIcons.boxArrowDown(PhosphorIconsStyle.regular)
                    : PhosphorIcons.boxArrowUp(PhosphorIconsStyle.regular),
                color: const Color(0xFFE4BF1C),
                onTap: () {
                  Navigator.pop(context);
                  onArquivar?.call(tipo == true);
                },
              ),
              const SizedBox(height: 16),
              _buildOptionButton(
                context: context,
                label: 'Editar categoria',
                icon: PhosphorIcons.pencil(PhosphorIconsStyle.regular),
                color: AppTheme.primaryColor,
                onTap: () {
                  Navigator.pop(context);
                  onEditar?.call();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          TransactionContainer(
            type: category.type ?? '',
            color: category.color ?? '',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              Customtext.capitalizeFirstLetter(category.name),
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.dynamicTextColor(context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _showActionSheet(context),
            child: Icon(
              PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.regular),
              color: AppTheme.dynamicTextColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildOptionButton({
  required BuildContext context,
  required String label,
  required IconData icon,
  required VoidCallback onTap,
  required Color color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

