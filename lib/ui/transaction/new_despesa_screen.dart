import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spendo/components/ExpandedComp.dart';
import 'package:spendo/components/comboBox/BankLoadedComboBox.dart';
import 'package:spendo/components/comboBox/CategoriesComboBox.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/bank_model.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/utils/theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewDespesaScreen extends ConsumerStatefulWidget {
  const NewDespesaScreen({super.key});

  @override
  ConsumerState<NewDespesaScreen> createState() => _NewDespesaScreenState();
}

class _NewDespesaScreenState extends ConsumerState<NewDespesaScreen> {
  final MoneyMaskedTextController _moneyController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  int _repeatCount = 1;
  DateTime selectedDate = DateTime.now();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  String categoria = '';
  final FocusNode _valorFocusNode = FocusNode();
  final FocusNode _tituloFocusNode = FocusNode();
  final FocusNode _descricaoFocusNode = FocusNode();
  List<TransactionModel> filteredSuggestions = [];
  BanksModel? bankSelected;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _valorFocusNode.requestFocus();
      final allDespesas =
          ref.read(transactionControllerProvider).where((t) => t.type == 'd');

      final grouped = <String, List<TransactionModel>>{};
      for (final t in allDespesas) {
        grouped.putIfAbsent(t.title.toLowerCase(), () => []).add(t);
      }

      final sorted = grouped.entries.toList()
        ..sort((a, b) => b.value.length.compareTo(a.value.length));

      setState(() {
        filteredSuggestions = sorted.map((e) => e.value.first).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionController =
        ref.read(transactionControllerProvider.notifier);

    void onSave() async {
      final response = await transactionController.addTransaction(
        transaction: TransactionModel(
          type: 'd', // 'r' para receita
          value: _moneyController.numberValue,
          title: _titleController.text,
          description: _descriptionController.text,
          category: categoria,
          date: selectedDate,
          repeat: _repeatCount,
          bank: bankSelected?.name ?? '',
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(
            context, 'Despesa adicionada com sucesso', 'success', 2);
        Navigator.of(context).pushReplacementNamed('/menu');
      }
    }

    final transactions = ref.watch(transactionControllerProvider);
    // Pegue só despesas
    final despesas = transactions.where((t) => t.type == 'd').toList();

    bool isSameDate(DateTime date1, DateTime date2) {
      return date1.year == date2.year &&
          date1.month == date2.month &&
          date1.day == date2.day;
    }

    bool hasData = _moneyController.numberValue > 0 ||
        _titleController.text.trim().isNotEmpty ||
        _descriptionController.text.trim().isNotEmpty;

    return WillPopScope(
      onWillPop: () async {
        if (hasData) {
          // Se tiver dados preenchidos, pede confirmação
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppTheme.dynamicCardColor(context),
                title: const Text('Tem certeza?'),
                content: const Text(
                    'Você tem dados não salvos. Quer realmente sair e perder as alterações?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Sair'),
                  ),
                ],
              );
            },
          );
          return shouldExit ?? false;
        }
        return true; // Fecha normalmente se não tiver dados
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.dynamicDespesaColor(context),
          title: const Text(
            'Nova despesa',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
          leading: IconButton(
            icon: const Icon(
              Iconsax.arrow_left,
              color: AppTheme.whiteColor,
            ),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/menu'),
          ),
        ),
        backgroundColor: AppTheme.dynamicDespesaColor(context),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque, // <- adiciona isso
          onTap: () {
            _tituloFocusNode
                .unfocus(); // <- garante que o campo título perca foco
            _valorFocusNode
                .unfocus(); // <- garante que o campo valor também perca
            _descricaoFocusNode
                .unfocus(); // <- e o campo descrição também perca foco
            FocusScope.of(context).unfocus(); // <- desfoca o resto
          },
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
                  focusNode: _valorFocusNode,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
      
              const SizedBox(height: 16),
      
              // Container branco ocupando toda a largura
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.dynamicBackgroundColor(context),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Título',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            RawAutocomplete<TransactionModel>(
                              textEditingController: _titleController,
                              focusNode: _tituloFocusNode,
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                final allReceitas = ref
                                    .read(transactionControllerProvider)
                                    .where((t) => t.type == 'd');
      
                                if (!_tituloFocusNode.hasFocus ||
                                    textEditingValue.text.trim().isEmpty) {
                                  return const Iterable<TransactionModel>.empty();
                                }
      
                                // Agrupa as transações pelo título e conta quantas vezes cada uma aparece
                                final Map<String, List<TransactionModel>>
                                    grouped = {};
      
                                for (var t in allReceitas) {
                                  final key = t.title.toLowerCase().trim();
                                  if (grouped.containsKey(key)) {
                                    grouped[key]!.add(t);
                                  } else {
                                    grouped[key] = [t];
                                  }
                                }
      
                                // Filtra os grupos que aparecem pelo menos 3 vezes
                                final frequentTitles = grouped.entries
                                    .where((entry) => entry.value.length >= 2)
                                    .map((entry) => entry.value.first)
                                    .toList();
      
                                // Agora filtra pelo que foi digitado
                                return frequentTitles.where((t) => t.title
                                    .toLowerCase()
                                    .contains(
                                        textEditingValue.text.toLowerCase()));
                              },
                              displayStringForOption: (TransactionModel option) =>
                                  option.title,
                              fieldViewBuilder: (context, controller, focusNode,
                                  onFieldSubmitted) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Digite um título',
                                    hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    filled: true,
                                    fillColor: AppTheme.dynamicCardColor(context),
                                    prefixIcon: Icon(
                                      Iconsax.text_block,
                                      size: 24,
                                    ),
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 18),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                );
                              },
                              optionsViewBuilder: (context, onSelected, options) {
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Material(
                                    color: AppTheme.dynamicModalColor(context),
                                    child: Container(
                                      padding:
                                          const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.dynamicBackgroundColor(
                                            context),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.08),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          )
                                        ],
                                      ),
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          final option = options.elementAt(index);
                                          return ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16, vertical: 4),
                                            leading: const Icon(Iconsax.repeat),
                                            title: Text(
                                              option.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (option.description != null &&
                                                    option
                                                        .description!.isNotEmpty)
                                                  Text(
                                                    option.description!,
                                                    style: const TextStyle(
                                                        fontSize: 13),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                Text(
                                                  'R\$ ${option.value.toStringAsFixed(2).replaceAll('.', ',')}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme
                                                        .dynamicReceitaColor(
                                                            context),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onTap: () {
                                              onSelected(option);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onSelected: (TransactionModel selected) {
                                setState(() {
                                  _titleController.text = selected.title;
                                  _descriptionController.text =
                                      selected.description ?? '';
                                  _moneyController.updateValue(selected.value);
                                });
      
                                // Fecha teclado corretamente
                                _tituloFocusNode.unfocus();
                                FocusScope.of(context).unfocus();
      
                                FloatingMessage(
                                  context,
                                  'Campos preenchidos com base em "${selected.title}"',
                                  'info',
                                  2,
                                );
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Descrição',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextField(
                              controller: _descriptionController,
                              focusNode: _descricaoFocusNode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Digite uma descrição',
                                hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                filled: true,
                                fillColor: AppTheme.dynamicCardColor(context),
                                prefixIcon: Icon(
                                  Iconsax.document,
                                  size: 24,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide
                                      .none,
                                  selectedColor:
                                      AppTheme.dynamicDespesaColor(context),
                                  backgroundColor:
                                      AppTheme.dynamicCardColor(context),
                                  label: Text(
                                    'Hoje',
                                    style: TextStyle(
                                      color: isSameDate(
                                              selectedDate, DateTime.now())
                                          ? Colors.white
                                          : AppTheme.dynamicTextColor(context),
                                    ),
                                  ),
                                  selected:
                                      isSameDate(selectedDate, DateTime.now()),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        selectedDate = DateTime.now();
                                      });
                                    }
                                  },
                                  checkmarkColor: Colors.white,
                                ),
                                SizedBox(width: 8),
                                ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide
                                      .none,
                                  selectedColor:
                                      AppTheme.dynamicDespesaColor(context),
                                  backgroundColor:
                                      AppTheme.dynamicCardColor(context),
                                  label: Text(
                                    'Ontem',
                                    style: TextStyle(
                                      color: isSameDate(
                                              selectedDate,
                                              DateTime.now()
                                                  .subtract(Duration(days: 1)))
                                          ? Colors.white
                                          : AppTheme.dynamicTextColor(context),
                                    ),
                                  ),
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
                                  checkmarkColor: Colors.white,
                                ),
                                SizedBox(width: 8),
                                ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide
                                      .none,
                                  selectedColor:
                                      AppTheme.dynamicDespesaColor(context),
                                  backgroundColor:
                                      AppTheme.dynamicCardColor(context),
                                  label: Text(
                                    selectedDate.isAfter(DateTime.now()
                                                .subtract(Duration(days: 1))) &&
                                            !isSameDate(
                                                selectedDate, DateTime.now())
                                        ? '${dateFormat.format(selectedDate)}'
                                        : 'Outro dia',
                                    style: TextStyle(
                                      color: !(isSameDate(
                                                  selectedDate, DateTime.now()) ||
                                              isSameDate(
                                                  selectedDate,
                                                  DateTime.now().subtract(
                                                      Duration(days: 1))))
                                          ? Colors.white
                                          : AppTheme.dynamicTextColor(context),
                                    ),
                                  ),
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
                                  checkmarkColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                        BankLoadedComboBox(
                          selected: bankSelected,
                          onSelect: (bank) {
                            setState(() {
                              bankSelected = bank;
                            });
                          },
                        ),
                        CategoriaComboBox(
                          onCategoriaSelecionada: (nome, tipo, cor) {
                            categoria = nome;
                          },
                        ),
                        Center(
                          child: Expandedcomp(
                            onRepetirChanged: (qtd) {
                              _repeatCount = qtd;
                            },
                          ),
                        ),
                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onSave();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: AppTheme.dynamicDespesaColor(context),
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
