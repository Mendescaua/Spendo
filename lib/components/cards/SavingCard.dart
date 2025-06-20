import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/utils/customText.dart';

class SavingCard extends StatelessWidget {
  SavingModel saving;
  SavingCard({super.key, required this.saving});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color.fromARGB(8, 0, 0, 0), // sombra bem leve
        //     offset: const Offset(0, 4),
        //     blurRadius: 6,
        //   ),
        // ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFE5EDFB), // azul claro de fundo
            ),
            child: const Icon(
              Iconsax.mobile, // ícone do celular
              color: Color(0xFF3B75FF), // azul do ícone
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      saving.title!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      Customtext.formatMoeda(saving.goalValue!) ??  Customtext.formatMoeda(0),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.6, // progresso da barra (60%)
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF3B75FF)),
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
