import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/models/transaction_model.dart';

import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/supabase_service.dart';

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, List<TransactionModel>>((ref) {
  return TransactionController(ref);
});

class TransactionController extends StateNotifier<List<TransactionModel>> {
  final SupabaseService _transaction = SupabaseService();
  final Ref ref;
  List<CategoryTransactionModel> categories = [];

  TransactionController(this.ref) : super([]);

  Future<String?> addTransaction(
      {required TransactionModel transaction}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (transaction.value <= 0) return 'Adicione um valor.';
    if (transaction.title.isEmpty) return 'Adicione um título.';
    if (transaction.title.length < 3) return 'Adicione um título maior.';
    if (transaction.category.isEmpty) return 'Selecione uma categoria.';

    try {
      final newTransaction = TransactionModel(
        uuid: userId,
        type: transaction.type,
        value: transaction.value,
        title: transaction.title,
        description: transaction.description,
        category: transaction.category,
        date: transaction.date,
      );
      await _transaction.addTransacao(newTransaction);
      // Atualiza o estado com a nova transação adicionada
      state = [...state, newTransaction];
      return null;
    } catch (e) {
      print('Erro ao adicionar transação: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> getTransaction() async {
    String? userId;
    int tentativas = 0;

    // Tenta pegar o userId até 10 vezes (com 100ms de delay entre cada uma)
    while ((userId = ref.read(currentUserId)) == null && tentativas < 10) {
      await Future.delayed(const Duration(milliseconds: 100));
      tentativas++;
    }

    if (userId == null) return 'Usuário não autenticado';

    try {
      final transacoes = await _transaction.getTransactions(userId);
      state = transacoes;
      return null;
    } catch (e) {
      print('Erro ao obter transação: $e');
      return 'Erro inesperado: $e';
    }
  }

  // Aqui eu uso apenas no categoriesField para carregar as categorias do banco
  Future<String?> getCategoryTransaction() async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    try {
      final categoriesList = await _transaction.getCategoryTransaction(userId);
      categories = categoriesList; // Guarda categorias numa variável separada
      return null;
    } catch (e) {
      print('Erro ao obter categoria: $e');
      return 'Erro inesperado: $e';
    }
  }

  Future<String?> addCategoryTransaction({
    required CategoryTransactionModel transaction,
  }) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (transaction.name.isEmpty) {
      return 'Adicione um nome para a categoria.';
    }

    try {
      // Garante que as categorias estejam carregadas
      if (categories.isEmpty) {
        final result = await getCategoryTransaction();
        if (result != null) return result;
      }

      // Verifica se já existe uma categoria com o mesmo nome (case sensitive)
      final jaExiste = categories.any((c) => c.name == transaction.name);

      if (jaExiste) {
        return 'Essa categoria já existe.';
      }

      final newCategory = CategoryTransactionModel(
        uuid: userId,
        name: transaction.name,
        type: transaction.type,
        color: transaction.color,
      );

      await _transaction.addCategoryTransaction(newCategory);

      categories = [...categories, newCategory];
      return null;
    } catch (e) {
      print('Erro ao adicionar categoria: $e');
      return 'Erro inesperado: $e';
    }
  }
}
