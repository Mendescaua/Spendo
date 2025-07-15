import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spendo/models/subscription_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;
  const SubscriptionCard({Key? key, required this.subscription}) : super(key: key);

  String calculateMonths(String period) {
  try {
    final parts = period.split(' até ');
    if (parts.length != 2) return "Sem informação";

    final format = DateFormat('dd/MM/yyyy');
    final startDate = format.parse(parts[0]);
    final endDate = format.parse(parts[1]);

    int totalMonths = (endDate.year - startDate.year) * 12 + (endDate.month - startDate.month);
    if (endDate.day >= startDate.day) {
      totalMonths += 1;
    }

    if (totalMonths <= 0) totalMonths = 1;

    int years = totalMonths ~/ 12; // divisão inteira
    int months = totalMonths % 12; // resto da divisão

    String result = "";

    if (years > 0) {
      result += years == 1 ? "1 ano" : "$years anos";
    }

    if (months > 0) {
      if (result.isNotEmpty) result += " e ";
      result += months == 1 ? "1 mês" : "$months meses";
    }

    if (result.isEmpty) {
      result = "0 meses";
    }

    return result;
  } catch (e) {
    return "Sem informação";
  }
}


  @override
  Widget build(BuildContext context) {
    final time = calculateMonths(subscription.time ?? "");

    return Container(
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: const Icon(
              Iconsax.card,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subscription.name ?? "Sem título",
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Customtext.formatMoeda(subscription.value),
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
