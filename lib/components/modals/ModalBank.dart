import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/components/comboBox/BankComboBox.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/components/comboBox/BankTypeComboBox.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/models/bank_model.dart';

class ModalBank extends ConsumerStatefulWidget {
  const ModalBank({super.key});

  @override
  ConsumerState<ModalBank> createState() => _ModalBankState();
}

class _ModalBankState extends ConsumerState<ModalBank> {
    Map<String, String>? selectedAccount;
    Map<String, dynamic>? selectedTypeAccount;

    void onSave() async {
      final BankController = ref.read(bankControllerProvider.notifier);
      final response = await BankController.addBank(
        bank: BanksModel(
          name: selectedAccount?['name'] ?? '',
          type: selectedTypeAccount?['name'] ?? ''
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        Navigator.of(context).pop(true);
        FloatingMessage(
            context, 'Conta bancária adicionada com sucesso', 'success', 2);
      }
    }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Adicionar nova Conta',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            BankComboBox(
              selected: selectedAccount,
              onSelect: (account) {
                setState(() {
                  selectedAccount = account;
                  print("Conta ${account}");
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Tipo de conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            BankTypeComboBox(
              selected: selectedTypeAccount,
              onSelect: (account) {
                setState(() {
                  selectedTypeAccount = account;
                  print("Tipo da conta ${account}");
                });
              },
            ),
            const SizedBox(height: 32),
            StyleButton(
              text: 'Adicionar',
              onClick: () {
                onSave();
              },
            ),
          ],
        ),
      ),
    );
  }
}
