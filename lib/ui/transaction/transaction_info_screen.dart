import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/ConfirmAlertDialog.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class TransactionInfoScreen extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  const TransactionInfoScreen({super.key, required this.transaction});

  @override
  ConsumerState<TransactionInfoScreen> createState() =>
      _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends ConsumerState<TransactionInfoScreen> {
  late TextEditingController _descriptionController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.transaction.description ?? '');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged(String value) {
    // Cancelar debounce anterior
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Iniciar novo debounce
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      final controller = ref.read(transactionControllerProvider.notifier);
      final response = await controller.updateTransactionDescription(
        widget.transaction,
        value.trim(),
      );

      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(context, 'Descrição atualizada', 'success', 1);
      }
    });
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        label: 'confirmar',
        onConfirm: () {
          Navigator.of(context).pop(); // Fecha o dialog
          onDelete(widget.transaction.id ?? 0);
        },
      ),
    );
  }

  void onDelete(int id) async {
    final controller = ref.read(transactionControllerProvider.notifier);
    final response = await controller.deleteTransaction(id: id);

    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      Navigator.of(context).pop();
      FloatingMessage(context, 'Transação deletada com sucesso', 'success', 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transaction = widget.transaction;
    return Scaffold(
      backgroundColor:
          Customtext.stringToColor(transaction.categoryColor ?? ''),
      body: Stack(
        children: [
          // AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                Customtext.capitalizeFirstLetter(transaction.title),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Iconsax.trash, color: Colors.white),
                  onPressed: () => _showDeleteConfirmationDialog(),
                ),
              ],
            ),
          ),

          // Info e conteúdo
          Positioned.fill(
            top: 200,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      Customtext.capitalizeFirstLetter(transaction.title),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo de descrição com onChanged
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Iconsax.document,
                              size: 20, color: Colors.grey.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Descrição',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLines: null,
                                  onChanged: _onDescriptionChanged,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: 'Digite a descrição...',
                                    hintStyle:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Infos adicionais
                    InfoTile(
                      icon: Iconsax.calendar,
                      label: 'Data e hora',
                      content: Customtext.formatarDataHora(transaction.date),
                    ),
                    InfoTile(
                      icon: Iconsax.tag,
                      label: 'Categoria',
                      content: transaction.categoryName ?? 'Não informada',
                    ),
                    InfoTile(
                      icon: Iconsax.bank,
                      label: 'Conta',
                      content: transaction.bank ?? 'Não informada',
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Valor no topo
          Positioned(
            left: 24,
            top: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Valor',
                    style:
                        TextStyle(color: Colors.grey.shade200, fontSize: 16)),
                const SizedBox(height: 4),
                Text(
                  transaction.type == 'r'
                      ? Customtext.formatMoeda(transaction.value)
                      : Customtext.formatMoeda(-transaction.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String content;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
