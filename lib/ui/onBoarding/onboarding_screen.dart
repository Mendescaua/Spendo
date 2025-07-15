import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/ui/onBoarding/category_step.dart';
import 'package:spendo/ui/onBoarding/meta_step.dart';
import 'package:spendo/ui/success_screen.dart';
import 'package:spendo/utils/theme.dart';

class OnboardingSetupScreen extends ConsumerStatefulWidget {
  const OnboardingSetupScreen({super.key});

  @override
  ConsumerState<OnboardingSetupScreen> createState() => _OnboardingSetupScreenState();
}

class _OnboardingSetupScreenState extends ConsumerState<OnboardingSetupScreen> {
  int currentStep = 0;
  bool categoriaCriada = false;
  bool contaCriada = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ref.read(bankControllerProvider.notifier).getBank();
    });
  }

  void proximoPasso() {
    if (currentStep == 0 && categoriaCriada) {
      setState(() {
        currentStep = 1;
      });
    } else if (!categoriaCriada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Crie pelo menos uma categoria')),
      );
    }
  }

  void finalizar() {
    if (contaCriada) {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SuccessScreen()),
    );
    } else {
      FloatingMessage(context, 'Escolha uma meta', 'info', 2);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: const Text("Configuração Inicial"),
        automaticallyImplyLeading:false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: currentStep == 0 ? buildCategoriaStep() : buildMetaStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoriaStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Passo 1: Categorias',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: CategoryStep(
            onSaved: () {
              setState(() {
                categoriaCriada = true;
                proximoPasso(); // avança para o próximo passo
              });
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildMetaStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Passo 2: Qual sua meta?',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        // Substitua por seu widget de conta
        MetaStep(
          onFinished: (){
            setState(() {
              contaCriada = true;
            });
          },
        ),
        const SizedBox(height: 20),
        StyleButton(
          text: 'Finalizar',
          onClick: finalizar,
        ),
      ],
    );
  }
}
