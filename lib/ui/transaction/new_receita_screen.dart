import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spendo/components/comboBox/CategoriesComboBox.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/utils/theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewReceitaScreen extends ConsumerStatefulWidget {
  const NewReceitaScreen({super.key});

  @override
  ConsumerState<NewReceitaScreen> createState() => _NewReceitaScreenState();
}

class _NewReceitaScreenState extends ConsumerState<NewReceitaScreen> {
  final MoneyMaskedTextController _moneyController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  String categoria = '';

  @override
  Widget build(BuildContext context) {
    final transactionController =
        ref.read(transactionControllerProvider.notifier);

    void onSave() async {
      final response = await transactionController.addTransaction(
        transaction: TransactionModel(
          type: 'r', // 'r' para receita
          value: _moneyController.numberValue,
          title: _titleController.text,
          description: _descriptionController.text,
          category: categoria,
          date: selectedDate,
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(
            context, 'Receita adicionada com sucesso', 'success', 2);
        Navigator.of(context).pushReplacementNamed('/menu');
      }
    }

    bool isSameDate(DateTime date1, DateTime date2) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.greenColor,
          title: const Text(
            'Nova receita',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
          leading: IconButton(
            icon: const Icon(
              Iconsax.arrow_left,
              color: AppTheme.whiteColor,
            ),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/menu'),
          ),
        ),
        backgroundColor: AppTheme.greenColor,
        body: GestureDetector(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Valor',
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),

                // TextField sem borda nenhuma
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    controller: _moneyController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Container branco ocupando toda a largura
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          const Text(
                            'Título',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Iconsax.text_block),
                              hintText: 'Digite um título',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AppTheme.greenColor,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Descrição',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Iconsax.attach_square),
                              hintText: 'Digite um descrição',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AppTheme.greenColor,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            'Data',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ChoiceChip(
                                label: Text('Hoje'),
                                selected:
                                    isSameDate(selectedDate, DateTime.now()),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedDate = DateTime.now();
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 8),
                              ChoiceChip(
                                label: Text('Ontem'),
                                selected: isSameDate(selectedDate,
                                    DateTime.now().subtract(Duration(days: 1))),
                                onSelected: (selected) {
                                  if (selected) {
                                    setState(() {
                                      selectedDate = DateTime.now()
                                          .subtract(Duration(days: 1));
                                    });
                                  }
                                },
                              ),
                              SizedBox(width: 8),
                              ChoiceChip(
                                label: Text(selectedDate.isAfter(DateTime.now()
                                            .subtract(Duration(days: 1))) &&
                                        !isSameDate(
                                            selectedDate, DateTime.now())
                                    ? '${dateFormat.format(selectedDate)}'
                                    : 'Outro dia'),
                                selected: !(isSameDate(
                                        selectedDate, DateTime.now()) ||
                                    isSameDate(
                                        selectedDate,
                                        DateTime.now()
                                            .subtract(Duration(days: 1)))),
                                onSelected: (selected) async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2101),
                                    locale: const Locale('pt', 'BR'),
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      selectedDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                          CategoriaComboBox(
                            onCategoriaSelecionada: (nome, tipo, cor) {
                              categoria = nome;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onSave();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppTheme.greenColor,
          child: const Icon(
            Iconsax.add,
            color: Colors.white,
            size: 32,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
