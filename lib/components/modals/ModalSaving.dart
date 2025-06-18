import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/models/subscription_model.dart';
import 'package:spendo/utils/theme.dart';

class Modalsaving extends ConsumerStatefulWidget {
  const Modalsaving({super.key});

  @override
  ConsumerState<Modalsaving> createState() => _ModalsavingState();
}

class _ModalsavingState extends ConsumerState<Modalsaving> {
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _valor = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final subscriptionController =
        ref.read(subscriptionControllerProvider.notifier);

    // void onSave() async {
    //   final response = await subscriptionController.addSubscription(
    //     subscription: SubscriptionModel(
    //       name: _titulo.text,
    //       value: _valor.text.isEmpty ? 0.0 : double.parse(_valor.text),
    //       time: selectedDuration.toString(),
    //     ),
    //   );
    //   if (response != null) {
    //     FloatingMessage(context, response, 'error', 2);
    //   } else {
    //     FloatingMessage(
    //         context, 'Assinatura adicionada com sucesso', 'success', 2);
    //     Navigator.of(context).pop();
    //   }
    // }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        width: double.infinity,
        height: size.height * 0.50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: const Text(
                'Adicionar novo cofrinho',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Título',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: _titulo,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.text_block),
                hintText: 'Título',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4678c0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            const Text(
              'Valor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: _valor,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.dollar_circle),
                hintText: 'Valor',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4678c0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 32),
            StyleButton(
                text: 'Adicionar',
                onClick: () {
                  // onSave();
                }),
          ],
        ),
      ),
    );
  }
}
