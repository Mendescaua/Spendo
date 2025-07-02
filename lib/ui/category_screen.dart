import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/cards/CategoryCard.dart';
import 'package:spendo/components/skeletons/skeletonCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  bool _loading = false;
  List<CategoryTransactionModel> categoriasBanco = [];
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadCategory();
    });
  }

  Future<void> loadCategory() async {
    setState(() => _loading = true);

    final controller = ref.read(transactionControllerProvider.notifier);
    final result = await controller.getCategoryTransaction();

    categoriasBanco = controller.categories;

    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas categorias',
        ),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _loading
                      ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppTheme.primaryColor, size: 64,
                        ),
                      )
                      : categoriasBanco.isEmpty
                          ? Center(
                              child: Text(
                                "Nenhuma transação encontrada",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: categoriasBanco.length,
                              itemBuilder: (context, index) {
                                return CategoryCard(
                                    category: categoriasBanco[index]);
                              },
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
