import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/components/modals/ModalSaving.dart';
import 'package:spendo/controllers/saving_controller.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavingInfoScreen extends ConsumerStatefulWidget {
  final SavingModel saving;
  const SavingInfoScreen({super.key, required this.saving});

  @override
  ConsumerState<SavingInfoScreen> createState() => _SavingInfoScreenState();
}

class _SavingInfoScreenState extends ConsumerState<SavingInfoScreen> {
  void _openAddTransactionModal(BuildContext context, {required String type}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: Modalsaving(
                      type: type,
                      saving: widget.saving,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savings = ref.watch(savingControllerProvider);
    final currentSaving =
        savings.firstWhere((item) => item.id == widget.saving.id);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.saving.title ?? 'Cofrinho',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
          leading: IconButton(
            icon: const Icon(
              Iconsax.arrow_left,
              color: AppTheme.whiteColor,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(
          //       Iconsax.edit,
          //       color: AppTheme.whiteColor,
          //     ),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meta',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Customtext.formatMoeda(widget.saving.goalValue ?? 0),
                style: const TextStyle(
                  color: AppTheme.whiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSaving.title ?? '',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: CircularPercentIndicator(
                              radius: 110.0,
                              lineWidth: 14.0,
                              animation: true,
                              animationDuration: 1000,
                              percent: (currentSaving.value ?? 0) /
                                  (currentSaving.goalValue == 0
                                      ? 1
                                      : currentSaving.goalValue!),
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${((currentSaving.value ?? 0) / (currentSaving.goalValue == 0 ? 1 : currentSaving.goalValue!) * 100).toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'concluído',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: AppTheme.primaryColor,
                              backgroundColor: Colors.grey.shade300,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoColumn(
                                icon: Iconsax.wallet_2,
                                label: 'Acumulado',
                                value: Customtext.formatMoeda(
                                    currentSaving.value ?? 0),
                                valueColor: Colors.black87,
                              ),
                              _InfoColumn(
                                icon: Iconsax.wallet_money,
                                label: 'Restante',
                                value: Customtext.formatMoeda(
                                    (currentSaving.goalValue ?? 0) -
                                        (currentSaving.value ?? 0)),
                                valueColor: Colors.grey[700]!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 16,
                      children: [
                        Expanded(
                          child: StyleButton(
                            color: Colors.grey.shade600,
                            icon: Iconsax.money_send,
                              text: 'Resgatar',
                              onClick: () {
                                _openAddTransactionModal(context, type: 'resgatar');
                              }),
                        ),
                        Expanded(
                          child: StyleButton(
                              text: 'Guardar',
                              icon: Iconsax.money_recive,
                              onClick: () {
                                _openAddTransactionModal(context, type: 'guardar');
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoColumn({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 28),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: valueColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
