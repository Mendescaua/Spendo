import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/components/comboBox/BankComboBox.dart';
import 'package:spendo/components/comboBox/BankFlagComboBox.dart';
import 'package:spendo/controllers/money_card_controller.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/models/money_card_model.dart';
import 'package:spendo/components/cards/MoneyCard.dart';
import 'package:spendo/utils/theme.dart';

class AddMoneyCardScreen extends ConsumerStatefulWidget {
  const AddMoneyCardScreen({super.key});

  @override
  ConsumerState<AddMoneyCardScreen> createState() => _AddMoneyCardScreenState();
}

class _AddMoneyCardScreenState extends ConsumerState<AddMoneyCardScreen> {
  final TextEditingController _numbercontroller = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();

  Map<String, String>? selectedAccount;
  Map<String, String>? selectedFlag;
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _datecontroller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(moneyCardControllerProvider.notifier);

    void onSave() async {
      final response = await controller.addMoneyCard(
        moneyCard: MoneyCardModel(
          name: selectedAccount?['name'] ?? '',
          number: double.tryParse(_numbercontroller.text) ?? 0,
          validity: selectedDate ?? DateTime.now(),
          flag: selectedFlag?['name'] ?? '',
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(context, 'Cartão adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
        backgroundColor: AppTheme.primaryColor,
        appBar: AppBar(
          title: const Text('Adicionar Cartão'),
          leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/menu'),
        ),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: AppTheme.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview do cartão já visível no topo
                SizedBox(
                  width: double.infinity,
                  child: MoneyCard(
                    cards: MoneyCardModel(
                      name: selectedAccount?['name'] ?? '',
                      number: double.tryParse(_numbercontroller.text) ?? 0,
                      validity: selectedDate ?? DateTime.now(),
                      flag: selectedFlag?['name'] ?? '',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Número',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: _numbercontroller,
                  onChanged: (_) => setState(() {}),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  buildCounter: (_,
                          {required currentLength,
                          required isFocused,
                          required maxLength}) =>
                      null,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.card),
                    hintText: 'Últimos 4 dígitos',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Banco',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                BankComboBox(
                  selected: selectedAccount,
                  onSelect: (account) {
                    setState(() {
                      selectedAccount = account;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Data de validade',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                TextField(
                  controller: _datecontroller,
                  readOnly: true,
                  onTap: () async {
                    await _selectDate(context);
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Iconsax.calendar),
                    hintText: 'Selecione a data',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Bandeira',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                BankFlagComboBox(
                  selected: selectedFlag,
                  onSelect: (flag) {
                    setState(() {
                      selectedFlag = flag;
                    });
                  },
                ),
                const SizedBox(height: 32),
                StyleButton(
                  text: 'Adicionar',
                  onClick: () {
                    onSave();
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
