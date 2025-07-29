import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/ui/saving/saving_info_screen.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

import 'package:animations/animations.dart';

class MetaCard extends StatelessWidget {
  final SavingModel saving;
  const MetaCard({super.key, required this.saving});

  @override
  Widget build(BuildContext context) {
    final value = saving.value ?? 0;
    final goalValue = saving.goalValue ?? 0;

    return OpenContainer(
      transitionDuration: const Duration(milliseconds: 500),
      transitionType: ContainerTransitionType.fade, // ou .fadeThrough
      closedElevation: 0,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      closedColor: AppTheme.dynamicCardColor(context),
      openBuilder: (context, _) => SavingInfoScreen(saving: saving),
      closedBuilder: (context, openContainer) => GestureDetector(
        onTap: openContainer,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppTheme.dynamicCardColor(context),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.dynamicBorderSavingColor(context),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  saving.picture ?? '',
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
      ),
    );
  }
}
