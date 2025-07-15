import 'package:flutter/material.dart';
import 'package:spendo/components/transactionContainer.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/ui/transaction/transaction_info_screen.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TransactionInfoScreen(
                  transaction: transaction,
                )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.dynamicCardColor(context),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
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
                  transaction.description == null ||
                          transaction.description!.isEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          Customtext.capitalizeFirstLetter(
                              Customtext.limitarDescricao(
                                  transaction.description ?? '')),
                          style: TextStyle(
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
  }
}
