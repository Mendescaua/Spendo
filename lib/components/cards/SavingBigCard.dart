import 'package:flutter/material.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class Savingbigcard extends StatelessWidget {
  final SavingModel saving;

  const Savingbigcard({
    super.key,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor, // vermelho do card
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            saving.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Balance',
                style: TextStyle(color: Colors.white70),
              ),
              const Spacer(),
              Text(
                Customtext.formatMoeda(saving.goalValue),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 12,
            minHeight: 6,
            backgroundColor: Colors.white30,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                Customtext.formatMoeda(saving.value),
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                Customtext.formatMoeda(saving.goalValue - saving.value),
                style: const TextStyle(color: Colors.white70),
              )
            ],
          ),
        ],
      ),
    );
  }
}
