import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/models/transaction_model.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/services/transaction.dart';

final transactionControllerProvider =
    StateNotifierProvider<TransactionController, List<TransactionModel>>((ref) {
  return TransactionController(ref);
});

class TransactionController extends StateNotifier<List<TransactionModel>> {
  final TransactionService _transaction = TransactionService();
  final Ref ref;
  List<CategoryTransactionModel> categories = [];

  TransactionController(this.ref) : super([]);

  Future<String?> addTransaction(
      {required TransactionModel transaction}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (transaction.value <= 0) {
      return 'Adicione um valor.';
    }

    if (transaction.title.isEmpty) {
      return 'Adicione um título.';
    } else if (transaction.title.length < 3) {
      return 'Adicione um titulo maior.';
    }

    if (transaction.category.isEmpty) {
      return 'Selecione uma categoria.';
    }

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
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    try {
      final transacoes = await _transaction.getTransacoesByUser(userId);
      state = transacoes; // Atualiza a lista com as transações do usuário
      return null;
    } catch (e) {
      print('Erro ao obter transação: $e');
      return 'Erro inesperado: $e';
    }
  }

  // CATEGORIAS DE TRANSAÇÃO
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

  Future<String?> addCategoryTransaction(
      {required CategoryTransactionModel transaction}) async {
    final userId = ref.read(currentUserId);
    if (userId == null) return 'Usuário não autenticado';

    if (transaction.name.isEmpty) {
      return 'Adicione um nome para a categoria.';
    }
    try {
      final newTransaction = CategoryTransactionModel(
        uuid: userId,
        name: transaction.name,
        type: transaction.type,
      );
      await _transaction.addCategoryTransaction(newTransaction);
      // Atualiza o estado com a nova transação adicionada
      categories = [...categories, newTransaction];
      return null;
    } catch (e) {
      print('Erro ao adicionar categoria: $e');
      return 'Erro inesperado: $e';
    }
  }
}
