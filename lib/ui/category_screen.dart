import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/CategoryCard.dart';
import 'package:spendo/components/modals/ModalArchivedCategory.dart';
import 'package:spendo/components/modals/ModalCategory.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final controller = ref.read(transactionControllerProvider.notifier);
    await controller.getCategoryTransaction();
    setState(() => _isLoading = false);
  }

  Future<void> _openCategoryModal(
      BuildContext context, CategoryTransactionModel category) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: ModalCategory(
                      category: category,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await _loadCategories(); // recarrega após fechar modal
  }

  Future<void> _openArchivedCategoryModal(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: ModalArchivedCategory()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await _loadCategories(); // recarrega após fechar modal
  }

  @override
  Widget build(BuildContext context) {
    final categorias = ref
        .watch(transactionControllerProvider.notifier)
        .categories
        .where((c) => c.isArchived != true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas categorias'),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.boxArrowDown(PhosphorIconsStyle.regular)),
            color: AppTheme.whiteColor,
            tooltip: 'Categorias arquivadas',
            onPressed: () => _openArchivedCategoryModal(context),
          )
        ],
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _isLoading
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                        color: AppTheme.primaryColor,
                        size: 64,
                      ),
                    )
                  : categorias.isEmpty
                      ? const Center(
                          child: Text(
                            "Nenhuma categoria encontrada",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: categorias.map((category) {
                              return CategoryCard(
                                category: category,
                                tipo: true,
                                onEditar: () =>
                                    _openCategoryModal(context, category),
                                onArquivar: (bool isArchived) async {
                                  final controller = ref.read(
                                      transactionControllerProvider.notifier);
                                  final response =
                                      await controller.updateCategoryIsArchived(
                                    category: category,
                                    isArchived: isArchived,
                                  );
                                  if (response != null) {
                                    FloatingMessage(
                                        context, response, 'error', 2);
                                  } else {
                                    FloatingMessage(
                                        context,
                                        'Categoria arquivada com sucesso',
                                        'success',
                                        2);
                                        await _loadCategories();
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            "/add_category",
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
