import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/banksContainer.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/ui/bank/bank_info_screen.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class BankHomeCard extends ConsumerWidget {
  final bool isHidden;

  const BankHomeCard({super.key, this.isHidden = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banks = ref.watch(bankControllerProvider);

    if (banks.isEmpty) {
      return const Center(child: Text("Nenhuma conta cadastrada."));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/bank'),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.bank,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Contas",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/bank');
                },
                icon: Icon(
                  PhosphorIcons.dotsThreeOutline(PhosphorIconsStyle.regular),
                  size: 26,
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: banks.length < 3 ? banks.length : 3,
            itemBuilder: (context, index) {
              final bank = banks[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BankInfoScreen(
                        banks: bank,
                      ),
                    ),
                  );
                },
                child: BankHomeCardItem(
                  title: bank.name ?? '',
                  type: bank.type ?? '',
                  isHidden: isHidden,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class BankHomeCardItem extends ConsumerWidget {
  final String title;
  final String type;
  final bool isHidden;

  const BankHomeCardItem({
    super.key,
    required this.title,
    required this.type,
    this.isHidden = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bankTotalProvider =
        FutureProvider.family<double, String>((ref, bankName) async {
      final controller = ref.read(bankControllerProvider.notifier);
      final info = await controller.getBankInfo(bankName: bankName, date: DateTime.now());
      return info?['total_value']?.toDouble() ?? 0.0;
    });

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Bankscontainer(name: title),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  type,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Consumer(
            builder: (context, ref, _) {
              final bankTotal = ref.watch(bankTotalProvider(title));
              return bankTotal.when(
                data: (value) => Text(
                  isHidden ? '*******' : Customtext.formatMoeda(value),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                loading: () => Text(
                  isHidden ? '*******' : '...',
                  style: const TextStyle(fontSize: 14),
                ),
                error: (err, stack) => Text(
                  isHidden ? '*******' : 'Erro',
                  style: const TextStyle(fontSize: 14),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
