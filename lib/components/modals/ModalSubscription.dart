import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/models/subscription_model.dart';
import 'package:spendo/utils/theme.dart';

class ModalSubscription extends ConsumerStatefulWidget {
  const ModalSubscription({super.key});

  @override
  ConsumerState<ModalSubscription> createState() => _ModalSubscriptionState();
}

class _ModalSubscriptionState extends ConsumerState<ModalSubscription> {
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _valor = TextEditingController();

  int selectedDuration = 1; // padrão 1 mês

  final List<Map<String, dynamic>> durations = [
    {'label': '1 mês', 'value': 1},
    {'label': '5 meses', 'value': 5},
    {'label': '1 ano', 'value': 12},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final subscriptionController =
        ref.read(subscriptionControllerProvider.notifier);

    void onSave() async {
      final response = await subscriptionController.addSubscription(
        subscription: SubscriptionModel(
          name: _titulo.text,
          value: _valor.text.isEmpty ? 0.0 : double.parse(_valor.text),
          time: selectedDuration.toString(),
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(
            context, 'Assinatura adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        width: double.infinity,
        height: size.height * 0.55,
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
                'Adicionar nova assinatura',
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
            SizedBox(height: 16),
            const Text(
              'Duração',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: durations.map((duration) {
                final isSelected = selectedDuration == duration['value'];
                return ChoiceChip(
                  label: Text(duration['label']),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      selectedDuration = duration['value'];
                    });
                  },
                  selectedColor: AppTheme.primaryColor,
                  backgroundColor: AppTheme.whiteColor,
              
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 32),
            StyleButton(
                text: 'Adicionar',
                onClick: () {
                  onSave();
                }),
          ],
        ),
      ),
    );
  }
}
