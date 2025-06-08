import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/models/transaction_model.dart';

class TransactionService {
  final String table = 'TRANSACTIONS';

  Future<List<TransactionModel>> getTransacoesByUser(String userId) async {
    final response = await supabase
        .from(table)
        .select()
        .eq('uuid', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => TransactionModel.fromJson(item))
        .toList();
  }

  Future<void> addTransacao(TransactionModel model) async {
    await supabase.from(table).insert(model.toJson());
  }

  Future<void> deleteTransacao(int id) async {
    await supabase.from(table).delete().eq('id', id);
  }

  Future<List<CategoryTransactionModel>> getCategoryTransaction(
      String userId) async {
    final response = await supabase
        .from('CATEGORY_TRANSACTIONS')
        .select()
        .eq('uuid', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => CategoryTransactionModel.fromJson(item))
        .toList();
  }

  Future<void> addCategoryTransaction(CategoryTransactionModel model) async {
    await supabase.from('CATEGORY_TRANSACTIONS').insert(model.toJson());
  }
}
