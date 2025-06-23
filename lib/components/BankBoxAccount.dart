import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class DropdownBoxAccount extends StatefulWidget {
  final Map<String, String>? selected;
  final Function(Map<String, String>) onSelect;

  const DropdownBoxAccount({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<DropdownBoxAccount> createState() => _DropdownBoxAccountState();
}

class _DropdownBoxAccountState extends State<DropdownBoxAccount> {
  final List<Map<String, String>> accounts = [
    {
      'name': 'Nubank',
      'icon': 'https://cdn-icons-png.flaticon.com/512/5968/5968984.png',
    },
    {
      'name': 'Banco do Brasil',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3371/3371858.png',
    },
    {
      'name': 'Itaú',
      'icon': 'https://cdn-icons-png.flaticon.com/512/5968/5968624.png',
    },
    {
      'name': 'Carteira Digital',
      'icon': 'https://cdn-icons-png.flaticon.com/512/10406/10406548.png',
    },
  ];

  void _openAccountModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SizedBox(
        height: 300,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16),
          itemCount: accounts.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, index) {
            final account = accounts[index];
            return ListTile(
              leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFE5E7EB), // fundo cinza claro
                  image: account['icon']!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(account['icon']!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: account['icon']!.isEmpty
                    ? const Icon(Iconsax.wallet,
                        color: Color(0xFF4678C0)) // cor primária
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
            if (selected != null)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFE5E7EB), // fundo cinza claro
                  image: selected['icon']!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(selected['icon']!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: selected['icon']!.isEmpty
                    ? const Icon(Iconsax.wallet,
                        color: Color(0xFF4678C0)) // cor primária
                    : null,
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Iconsax.wallet, color: AppTheme.primaryColor),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selected?['name'] ?? 'Selecione uma conta',
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
