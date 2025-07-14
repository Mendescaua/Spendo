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
    if (transaction.bank.isEmpty) return 'Selecione um banco.';

    try {
      final newTransaction = TransactionModel(
        uuid: userId,
        type: transaction.type,
        value: transaction.value,
        title: transaction.title,
        description: transaction.description,
        category: transaction.category,
        date: transaction.date,
        repeat: transaction.repeat,
        bank: transaction.bank,
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

  // Future<String?> deleteTransaction(String transactionId) async {
  //   final userId = ref.read(currentUserId);
  //   if (userId == null) return 'Usuário não autenticado';

  //   try {
  //     await _transaction.deleteTransaction(transactionId, userId);
  //     // Atualiza o estado removendo a transação deletada
  //     state = state.where((t) => t.id != transactionId).toList();
  //     return null;
  //   } catch (e) {
  //     print('Erro ao deletar transação: $e');
  //     return 'Erro inesperado: $e';
  //   }
  // }

 Future<String?> updateTransactionDescription(
  TransactionModel transaction,
  String newDescription,
) async {
  try {
    final updated = transaction.copyWith(description: newDescription);

    await _transaction.updateTransaction(updated, updated.id!);

    // Atualiza o estado com a transação atualizada
    state = state.map((t) {
      return t.id == updated.id ? updated : t;
    }).toList();

    return null;
  } catch (e) {
    print('Erro ao atualizar descrição: $e');
    return 'Erro inesperado: $e';
  }
}


  // Aqui eu uso apenas no categoriesField para carregar as categorias do banco
  Future<String?> getCategoryTransaction() async {
  final userId = ref.read(currentUserId);
  if (userId == null) return 'Usuário não autenticado';

  try {
    final categoriesList = await _transaction.getCategoryTransaction(userId);

    categories = categoriesList;


    return null;
  } catch (e) {
    print('Erro ao obter categoria: $e');
    return 'Erro inesperado: $e';
  }
}

List<CategoryTransactionModel> getArchivedCategories() =>
    categories.where((cat) => cat.isArchived == true).toList();


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

Future<String?> updateCategoryTransaction({
  required CategoryTransactionModel category,
  String? newName,
  String? newColor,
  String? newType,
}) async {
  final userId = ref.read(currentUserId);
  if (userId == null) return 'Usuário não autenticado';

  if (newName == null || newName.trim().isEmpty) {
    return 'Adicione um nome para a categoria.';
  }
  if (newColor == null || newColor.trim().isEmpty) {
    return 'Adicione uma cor para a categoria.';
  }
  if (newType == null || newType.trim().isEmpty) {
    return 'Adicione um tipo para a categoria.';
  }

  // Garante que as categorias estão carregadas
  if (categories.isEmpty) {
    final result = await getCategoryTransaction();
    if (result != null) return result;
  }

  // Verifica se já existe uma categoria com o mesmo nome (ignorando o ID atual)
  final nameAlreadyExists = categories.any((c) =>
      c.name.trim().toLowerCase() == newName.trim().toLowerCase() &&
      c.id != category.id);

  if (nameAlreadyExists) {
    return 'Já existe uma categoria com esse nome.';
  }

  try {
    final updatedCategory = category.copyWith(
      name: newName,
      color: newColor,
      type: newType,
    );

    // Atualiza categoria na tabela categories
    await _transaction.updateCategoryTransaction(
        updatedCategory, category.id!);

    // Atualiza a lista local
    categories = categories.map((c) {
      return c.id == category.id ? updatedCategory : c;
    }).toList();

    final nameChanged = category.name != newName;

    // Atualiza as transações se o nome da categoria mudou
    if (nameChanged) {
      final affectedTransactions = state
          .where((t) =>
              t.category.trim().toLowerCase() ==
              category.name.trim().toLowerCase())
          .toList();

      for (var oldTransaction in affectedTransactions) {
        final transactionUuid = oldTransaction.uuid ?? userId;

        if (transactionUuid == null) {
          continue;
        }

        final updatedTransaction =
            oldTransaction.copyWith(category: newName);

        // Atualiza a transação na tabela transactions
        await _transaction.updateTransactionCategoryOnly(
          oldCategoryName: category.name,
          newCategoryName: newName,
          userUuid: userId,
        );

        // Atualiza o estado local
        state = state.map((t) {
          return t.id == oldTransaction.id ? updatedTransaction : t;
        }).toList();
      }
    }

    return null;
  } catch (e) {
    print('Erro ao atualizar categoria: $e');
    return 'Erro inesperado: $e';
  }
}


  Future<String?> updateCategoryIsArchived({
  required CategoryTransactionModel category,
  required bool isArchived,
}) async {
  final userId = ref.read(currentUserId);
  if (userId == null) return 'Usuário não autenticado';

  try {
    // Cria uma nova categoria com o valor isArchived atualizado
    final updatedCategory = category.copyWith(
      isArchived: isArchived,
    );

    // Atualiza no banco (implementação no SupabaseService)
    await _transaction.updateCategoryIsArchived(updatedCategory, category.id!);

    // Atualiza localmente a lista categories
    categories = categories.map((c) {
      return c.id == category.id ? updatedCategory : c;
    }).toList();

    return null;
  } catch (e) {
    print('Erro ao atualizar status arquivado da categoria: $e');
    return 'Erro inesperado: $e';
  }
}

}
