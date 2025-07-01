import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class BankFlagComboBox extends StatefulWidget {
  final Map<String, String>? selected;
  final Function(Map<String, String>) onSelect;

  const BankFlagComboBox({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<BankFlagComboBox> createState() => _BankComboBoxState();
}

class _BankComboBoxState extends State<BankFlagComboBox> {
  final List<Map<String, String>> accounts = [
    {'name': 'Mastercard', 'icon': 'assets/images/banks/mastercard.png'},
    {'name': 'Visa', 'icon': 'assets/images/banks/visa.png'},
    {'name': 'Elo', 'icon': 'assets/images/EloLogo.png'},
  ];

  void _openAccountModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.dynamicBackgroundColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Selecione a bandeira',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: accounts.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final account = accounts[index];
                  return ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFE5E7EB),
                        image: account['icon']!.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(account['icon']!),
                              )
                            : null,
                      ),
                      child: account['icon']!.isEmpty
                          ? const Icon(Iconsax.wallet,
                              color: Color(0xFF4678C0))
                          : null,
                    ),
                    title: Text(account['name']!),
                    onTap: () {
                      widget.onSelect(account);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
          border: Border.all(color: AppTheme.dynamicTextColor(context),),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            if (selected != null)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFE5E7EB),
                  image: selected['icon']!.isNotEmpty
                      ? DecorationImage(
                          image: AssetImage(selected['icon']!),
                        )
                      : null,
                ),
                child: selected['icon']!.isEmpty
                    ? const Icon(Iconsax.wallet,
                        color: Color(0xFF4678C0))
                    : null,
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Iconsax.wallet, color: AppTheme.primaryColor),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected?['name'] ?? 'Selecione uma bandeira',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
