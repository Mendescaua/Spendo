import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class BankComboBox extends StatefulWidget {
  final Map<String, String>? selected;
  final Function(Map<String, String>) onSelect;

  const BankComboBox({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<BankComboBox> createState() => _BankComboBoxState();
}

class _BankComboBoxState extends State<BankComboBox> {
  final List<Map<String, String>> accounts = [
  { 'name': 'Carteira Digital', 'icon': '' },
  { 'name': 'Nubank', 'icon': 'assets/images/banks/nuBank.png' },
  { 'name': 'Banco do Brasil', 'icon': 'assets/images/banks/bancobrasil.png' },
  { 'name': 'Itaú', 'icon': 'assets/images/banks/itau.png' },
  { 'name': 'Alelo', 'icon': 'assets/images/banks/alelo.png' },
  { 'name': 'Banco BV', 'icon': 'assets/images/banks/bancoBv.png' },
  { 'name': 'Banco Pan', 'icon': 'assets/images/banks/bancoPan.png' },
  { 'name': 'BTG', 'icon': 'assets/images/banks/btg.png' },
  { 'name': 'C6 Bank', 'icon': 'assets/images/banks/c6.png' },
  { 'name': 'Caixa', 'icon': 'assets/images/banks/caixa.png' },
  { 'name': 'Flash', 'icon': 'assets/images/banks/flash.png' },
  { 'name': 'Itaú Ion', 'icon': 'assets/images/banks/itauIon.png' },
  { 'name': 'Itaú ITI', 'icon': 'assets/images/banks/itauIti.png' },
  { 'name': 'Mastercard', 'icon': 'assets/images/banks/mastercard.png' },
  { 'name': 'Next', 'icon': 'assets/images/banks/next.png' },
  { 'name': 'Nomad', 'icon': 'assets/images/banks/nomad.png' },
  { 'name': 'Paybank', 'icon': 'assets/images/banks/paybank.png' },
  { 'name': 'Pluxxe', 'icon': 'assets/images/banks/pluxxe.png' },
  { 'name': 'Porto Seguro', 'icon': 'assets/images/banks/portoBanco.png' },
  { 'name': 'Rico', 'icon': 'assets/images/banks/rico.png' },
  { 'name': 'Safra', 'icon': 'assets/images/banks/safra.png' },
  { 'name': 'Santander', 'icon': 'assets/images/banks/santander.png' },
  { 'name': 'Sicoob', 'icon': 'assets/images/banks/sicoob.png' },
  { 'name': 'Sicred', 'icon': 'assets/images/banks/sicred.png' },
  { 'name': 'Stone', 'icon': 'assets/images/banks/stone.png' },
  { 'name': 'Ticket', 'icon': 'assets/images/banks/ticket.png' },
  { 'name': 'VR', 'icon': 'assets/images/banks/vr.png' },
  { 'name': 'Visa', 'icon': 'assets/images/banks/visa.png' },
  { 'name': 'XP', 'icon': 'assets/images/banks/xp.png' },
  { 'name': 'Bradesco', 'icon': 'assets/images/banks/bradesco.png' },
  { 'name': 'BMG', 'icon': 'assets/images/banks/bmg.png' },
  { 'name': 'Hipercard', 'icon': 'assets/images/banks/hipercard.png' },
  { 'name': 'Inter', 'icon': 'assets/images/banks/inter.png' },
  { 'name': 'Mercado Pago', 'icon': 'assets/images/banks/mercadoPago.png' },
  { 'name': 'Neon', 'icon': 'assets/images/banks/neon.png' },
  { 'name': 'PayPal', 'icon': 'assets/images/banks/paypal.png' },
  { 'name': 'PicPay', 'icon': 'assets/images/banks/picpay.png' },
  { 'name': 'Will Bank', 'icon': 'assets/images/banks/willBank.png' },
];

void _openAccountModal() {
  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredAccounts = [...accounts];

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.dynamicBackgroundColor(context),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 400,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar conta...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setModalState(() {
                        filteredAccounts = accounts
                            .where((account) =>
                                account['name']!
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredAccounts.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      final account = filteredAccounts[index];
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
                  color: const Color(0xFFE5E7EB), // fundo cinza claro
                  image: selected['icon']!.isNotEmpty
                      ? DecorationImage(
                          image: AssetImage(selected['icon']!),
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
