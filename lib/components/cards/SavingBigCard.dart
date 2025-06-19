import 'package:flutter/material.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/ui/saving/saving_info_screen.dart';
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
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Customtext.stringToColor(saving.colorCard ?? '#FF4678c0'),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              saving.title ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  '${_getPercent()}% concluído',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                Text(
                  Customtext.formatMoeda(goalValue),
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
              value: (goalValue == 0) ? 0 : (value / goalValue).clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white30,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppTheme.whiteColor),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  Customtext.formatMoeda(value),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  Customtext.formatMoeda(goalValue - value),
                  style: const TextStyle(color: Colors.white70),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
