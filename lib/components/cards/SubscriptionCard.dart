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

    int yearDiff = endDate.year - startDate.year;
    int monthDiff = endDate.month - startDate.month;
    int dayDiff = endDate.day - startDate.day;

    int totalMonths = yearDiff * 12 + monthDiff;
    if (dayDiff < 0) {
      totalMonths -= 1;
    }

    if (totalMonths < 0) totalMonths = 0;

    int years = totalMonths ~/ 12;
    int months = totalMonths % 12;

    String result = "";
    if (years > 0) {
      result += years == 1 ? "12 meses" : "$years anos";
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
