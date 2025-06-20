import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/ui/saving/saving_info_screen.dart';
import 'package:spendo/utils/base64.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class MetaCard extends StatelessWidget {
  SavingModel saving;
  MetaCard({super.key, required this.saving});

  @override
  Widget build(BuildContext context) {
    final value = saving.value ?? 0;
    final goalValue = saving.goalValue ?? 0;

    String _getPercent() {
      if (goalValue == 0) return '0';
      final percent = (value / goalValue * 100).clamp(0, 100);
      return percent.toStringAsFixed(0);
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SavingInfoScreen(
              saving: saving,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.grey.shade300, width: 1), // Borda fina
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image(
                image: base64ToImage(saving.picture ?? ''),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    saving.title!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        Customtext.formatMoeda(value),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        Customtext.formatMoeda(goalValue),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LinearPercentIndicator(
                lineHeight: 8.0,
                percent: (goalValue == 0)
                    ? 0.0
                    : (value / goalValue).clamp(0.0, 1.0),
                backgroundColor: Colors.grey.shade300,
                progressColor: AppTheme.primaryColor,
                barRadius: const Radius.circular(32),
                animation: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
