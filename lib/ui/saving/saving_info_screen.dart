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
    return Scaffold(
      body: Stack(
        children: [
          // 🔹 Imagem + AppBar + Texto "Meta"
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 220,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.saving.picture ?? '',
                      fit: BoxFit.cover,
                    ),
                    // Sombra subindo de baixo pra cima
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black
                                .withOpacity(0.8), // sombra na parte de baixo
                            Colors.transparent, // parte de cima sem sombra
                          ],
                          stops: [0.0, 0.6], // até 60% da altura
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    
          // 🔹 AppBar sobre a imagem
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                widget.saving.title ?? 'Meta',
                style: const TextStyle(color: Colors.white),
              ),
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
    
          // 🔹 Texto "Meta"
          Positioned(
            left: 16,
            top: 110,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Meta',
                  style: TextStyle(
                    color: Colors.grey.shade200,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.7),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Customtext.formatMoeda(widget.saving.goalValue ?? 0),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.7),
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    
          // 🔹 Container branco preenchendo todo o restante da tela
          Positioned.fill(
            top: 186, // altura da imagem menos um pouco para sobrepor
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, -3),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      // em caso de overflow
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentSaving.title ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w900,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'concluído',
                                    style: TextStyle(
                                        fontSize: 14),
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
                              ),
                              _InfoColumn(
                                icon: Iconsax.wallet_money,
                                label: 'Restante',
                                value: Customtext.formatMoeda(
                                    (currentSaving.goalValue ?? 0) -
                                        (currentSaving.value ?? 0)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StyleButton(
                          color: Colors.grey.shade600,
                          icon: Iconsax.money_send,
                          text: 'Retirar',
                          textSize: 16,
                          onClick: () {
                            _openAddTransactionModal(context,
                                type: 'retirar');
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StyleButton(
                          text: 'Adicionar',
                          textSize: 16,
                          icon: Iconsax.money_recive,
                          onClick: () {
                            _openAddTransactionModal(context,
                                type: 'adicionar');
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoColumn({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
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
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
