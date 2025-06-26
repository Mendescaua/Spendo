import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class BankTypeComboBox extends StatefulWidget {
  final Map<String, dynamic>? selected;
  final Function(Map<String, dynamic>) onSelect;

  const BankTypeComboBox({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<BankTypeComboBox> createState() => _BankTypeComboBoxState();
}

class _BankTypeComboBoxState extends State<BankTypeComboBox> {
  final List<Map<String, dynamic>> typeAccount = [
    { 'name': 'Conta corrente', 'icon': Iconsax.bank },
    { 'name': 'Carteira', 'icon': Iconsax.wallet },
    { 'name': 'Poupança', 'icon': Icons.savings_outlined },
    { 'name': 'Conta salário', 'icon': Iconsax.wallet_money },
    { 'name': 'Investimentos', 'icon': Iconsax.chart_2 },
    { 'name': 'VR/VA', 'icon': Iconsax.ticket },
    { 'name': 'Transporte', 'icon': Iconsax.bus },
    { 'name': 'Outros...', 'icon': Iconsax.more },
  ];

  void _openAccountModal() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Selecione o tipo de conta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: typeAccount.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) {
                  final account = typeAccount[index];
                  return ListTile(
                    leading: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFE5E7EB),
                      ),
                      child: Icon(account['icon'], color: const Color(0xFF4678C0)),
                    ),
                    title: Text(account['name']),
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
          border: Border.all(color: const Color.fromARGB(127, 0, 0, 0)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                selected?['icon'] ?? Iconsax.wallet_3,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected?['name'] ?? 'Selecione um tipo',
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
