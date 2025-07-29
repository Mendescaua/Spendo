import 'package:flutter/material.dart';
import 'package:animations/animations.dart'; // <--- importe o pacote
import 'package:spendo/components/transactionContainer.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/ui/transaction/transaction_info_screen.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
  margin: const EdgeInsets.only(bottom: 12),  // margem externa ao OpenContainer
  child: OpenContainer(
    transitionDuration: const Duration(milliseconds: 500),
    openBuilder: (context, _) => TransactionInfoScreen(transaction: transaction),
    closedElevation: 0,
    closedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    closedColor: AppTheme.dynamicCardColor(context),
    openColor: Theme.of(context).scaffoldBackgroundColor,
    closedBuilder: (context, openContainer) {
      return GestureDetector(
        onTap: openContainer,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.dynamicCardColor(context),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              TransactionContainer(
                type: transaction.categoryType ?? '',
                color: transaction.categoryColor ?? '',
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Customtext.capitalizeFirstLetter(transaction.title),
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: AppTheme.dynamicTextColor(context),
                      ),
                    ),
                    SizedBox(height: 4),
                    (transaction.description == null || transaction.description!.isEmpty)
                        ? const SizedBox.shrink()
                        : Text(
                            Customtext.capitalizeFirstLetter(
                                Customtext.limitarDescricao(transaction.description ?? '')),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                  ],
                ),
              ),
              Text(
                Customtext.formatMoeda(transaction.value),
                style: TextStyle(
                  color: transaction.type == 'r'
                      ? AppTheme.greenColor
                      : AppTheme.dynamicRedColor(context),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    },
  ),
);

  }
}
