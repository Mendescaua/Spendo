import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/banksContainer.dart';
import 'package:spendo/components/cards/BankCard.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/models/bank_model.dart';
import 'package:spendo/utils/theme.dart';

class BankLoadedComboBox extends ConsumerStatefulWidget {
  final BanksModel? selected;
  final Function(BanksModel) onSelect;

  const BankLoadedComboBox({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  ConsumerState<BankLoadedComboBox> createState() => _BankLoadedComboBoxState();
}

class _BankLoadedComboBoxState extends ConsumerState<BankLoadedComboBox> {
  void _openAccountModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.dynamicBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          final banks = ref.read(bankControllerProvider);

          return Container(
            width: double.infinity,
            height: 400,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Selecione uma conta',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.dynamicTextColor(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  child: banks.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.separated(
                          itemCount: banks.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final bank = banks[index];
                            return InkWell(
                              onTap: () {
                                widget.onSelect(bank);
                                Navigator.of(context).pop();
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: BankCardItem(
                                title: bank.name ?? '',
                                type: bank.type ?? '',
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    return GestureDetector(
      onTap: _openAccountModal,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.dynamicTextColor(context)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              if (selected != null)
                SizedBox(
                  width: 36,
                  height: 36,
                  child: Bankscontainer(name: selected.name ?? ''),
                )
              else
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.bank,
                    color: AppTheme.whiteColor,
                    size: 20,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selected?.name ?? 'Selecione uma conta',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (selected != null && selected.type != null)
                      Text(
                        selected.type!,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.dynamicTextColor(context)
                              .withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_down),
            ],
          )),
    );
  }
}
