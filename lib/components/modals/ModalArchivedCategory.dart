import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/CategoryCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class ModalArchivedCategory extends ConsumerStatefulWidget {
  const ModalArchivedCategory({super.key});

  @override
  ConsumerState<ModalArchivedCategory> createState() => _ModalArchivedCategoryState();
}

class _ModalArchivedCategoryState extends ConsumerState<ModalArchivedCategory> {
  List<CategoryTransactionModel> categoriasArquivadas = [];

  @override
  void initState() {
    super.initState();
    final controller = ref.read(transactionControllerProvider.notifier);
    categoriasArquivadas = controller.getArchivedCategories();
  }

  void _handleDesarquivar(CategoryTransactionModel cat, BuildContext context) async {
    final controller = ref.read(transactionControllerProvider.notifier);
    final response = await controller.updateCategoryIsArchived(
      category: cat,
      isArchived: false,
    );
    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      setState(() {
        categoriasArquivadas.removeWhere((c) => c.id == cat.id);
      });
      FloatingMessage(context, 'Categoria desarquivada com sucesso', 'success', 2);

      if (categoriasArquivadas.isEmpty) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Navigator.of(context).pop();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.dynamicBackgroundColor(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
        width: double.infinity,
        height: size.height * 0.60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Categorias arquivadas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: categoriasArquivadas.isEmpty
                  ? const Center(
                      child: Text('Nenhuma categoria arquivada encontrada'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: categoriasArquivadas
                            .take(3)
                            .map((cat) => CategoryCard(
                                  category: cat,
                                  tipo: true, // Categoria arquivada
                                  onArquivar: (_) =>
                                      _handleDesarquivar(cat, context),
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
