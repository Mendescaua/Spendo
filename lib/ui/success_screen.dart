import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/AnimatedSuccessIcon.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/controllers/user_controller.dart';
import 'package:spendo/utils/theme.dart';

class SuccessScreen extends ConsumerStatefulWidget {
  const SuccessScreen({super.key});

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(userControllerProvider.notifier).getUser();
      ref.read(bankControllerProvider.notifier).getBank();
      ref.read(transactionControllerProvider.notifier).getCategoryTransaction();
    });

    //Após 8 segundos, fecha a tela
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // const AnimatedSuccessIcon(),

              const SizedBox(height: 24),
              Column(
                children: [
                  Icon(
                    PhosphorIcons.target(PhosphorIconsStyle.regular),
                    color: AppTheme.whiteColor,
                    size: 200,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Cadastro Concluído!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const Text(
                    'Aguarde enquanto carregamos seus dados.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              LoadingAnimationWidget.staggeredDotsWave(
                  color: AppTheme.whiteColor, size: 100)
            ],
          ),
        ),
      ),
    );
  }
}
