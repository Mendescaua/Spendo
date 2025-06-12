import 'package:flutter/material.dart';
import 'package:spendo/components/buttons/OutlineButton.dart';
import 'package:spendo/ui/transaction/new_despesa_screen.dart';
import 'package:spendo/ui/transaction/new_receita_screen.dart';

class ModalTransaction extends StatelessWidget {
  const ModalTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
        width: double.infinity,
        height: size.height * 0.38,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'O que você quer Adicionar?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            OutlineButton(
              tipo: 'receita',
              onClick: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const NewReceitaScreen()));
              },
            ),
            OutlineButton(
              tipo: 'despesa',
              onClick: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const NewDespesaScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
