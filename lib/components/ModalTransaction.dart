import 'package:flutter/material.dart';
import 'package:spendo/components/buttons/OutlineButton.dart';
import 'package:spendo/ui/new_income_screen.dart';

class ModalTransaction extends StatelessWidget {
  const ModalTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 24),
      width: double.infinity,
      height: size.height * 0.34,
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          OutlineButton(
            tipo: 'receita',
            onClick: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ReceitaValorInput()));},
          ),
          OutlineButton(
            tipo: 'despesa',
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
