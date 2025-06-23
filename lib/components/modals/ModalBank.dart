import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/BankBoxAccount.dart';
import 'package:spendo/components/buttons/StyleButton.dart';

class ModalBank extends ConsumerStatefulWidget {
  const ModalBank({super.key});

  @override
  ConsumerState<ModalBank> createState() => _ModalBankState();
}

class _ModalBankState extends ConsumerState<ModalBank> {
  final TextEditingController _valuecontroller = TextEditingController();
  Map<String, String>? selectedAccount;
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
            DropdownBoxAccount(
              selected: selectedAccount,
              onSelect: (account) {
                setState(() {
                  selectedAccount = account;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Descrição',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextField(
              controller: _valuecontroller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.attach_square),
                hintText: 'Descrição',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: Color(0xFF4678c0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            StyleButton(
              text: 'Adicionar',
              onClick: () {
                // onSave();
              },
            ),
          ],
        ),
      ),
    );
  }
}
