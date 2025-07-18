import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/components/banksContainer.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/ui/bank/bank_info_screen.dart';
import 'package:spendo/utils/theme.dart';

class BankCard extends ConsumerWidget {
  const BankCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(bankControllerProvider);

    if (banks.isEmpty) {
      return const Center(child: Text("Nenhuma conta cadastrada."));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.08),
        //     blurRadius: 12,
        //     offset: Offset(0, 2),
        //   )
        // ],
      ),
      child: ListView.builder(
        shrinkWrap:
            true, // para usar dentro de Column/ScrollView sem expandir infinito
        physics:
            const NeverScrollableScrollPhysics(), // desativa scroll interno, para não conflitar
        itemCount: banks.length,
        itemBuilder: (context, index) {
          final bank = banks[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BankInfoScreen(banks: bank,),
                ),
              );
            },
            child: BankCardItem(
              title: bank.name ?? '',
              type: bank.type ?? '', // ou banco.url se tiver
            ),
          );
        },
      ),
    );
  }
}

class BankCardItem extends ConsumerWidget {
  final String title;
  final String type;

  const BankCardItem({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Bankscontainer(name: title),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              Text(
                type, // Pode ser atualizado futuramente
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
