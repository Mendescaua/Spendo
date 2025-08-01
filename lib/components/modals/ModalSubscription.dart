import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart'; // Import para formatar datas
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
  final TextEditingController _titlecontroller = TextEditingController();

  int selectedDuration = 1; // padrão 1 mês

  final List<Map<String, dynamic>> durations = [
    {'label': '1 mês', 'value': 1},
    {'label': '5 meses', 'value': 5},
    {'label': '12 meses', 'value': 12},
  ];

  final _valuecontroller = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final subscriptionController =
        ref.read(subscriptionControllerProvider.notifier);

    void onSave() async {
      if (isLoading) return;
      DateTime now = DateTime.now();
      DateTime endDate =
          DateTime(now.year, now.month + selectedDuration, now.day);

      setState(() {
        isLoading = true;
      });
      final formatter = DateFormat('dd/MM/yyyy');
      String startStr = formatter.format(now);
      String endStr = formatter.format(endDate);

      String rangeStr = '$startStr até $endStr';

      final response = await subscriptionController.addSubscription(
        subscription: SubscriptionModel(
          name: _titlecontroller.text,
          value: _valuecontroller.numberValue,
          time: rangeStr, // salva como "10/07/2025 até 10/11/2025"
        ),
      );
      setState(() {
        isLoading = false;
      });
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(
            context, 'Assinatura adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.dynamicModalColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          width: double.infinity,
          height: size.height * 0.62,
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
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Adicionar nova assinatura',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Título',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: _titlecontroller,
                
               decoration: InputDecoration(
                  hintText: 'Valor',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppTheme.dynamicTextFieldColor(context),
                  prefixIcon: Icon(
                    Iconsax.text_block,
                    size: 24,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Valor',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: _valuecontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Valor',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppTheme.dynamicTextFieldColor(context),
                  prefixIcon: Icon(
                    Iconsax.dollar_circle,
                    size: 24,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Duração',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(8),
                    side: BorderSide.none,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: AppTheme.dynamicTextFieldColor(context),
                    checkmarkColor: AppTheme.whiteColor,
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              StyleButton(
                text: 'Adicionar',
                onClick: isLoading ? null : onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
