import 'package:flutter/material.dart';
import 'package:spendo/core/supabse_client.dart';
import 'package:spendo/models/bank_model.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/models/money_card_model.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/models/subscription_model.dart';
import 'package:spendo/models/transaction_model.dart';

class SupabaseService {
  final String table = 'TRANSACTIONS';

  // Future<List<TransactionModel>> getTransacoesByUser(String userId) async {
  //   final response = await supabase
  //       .from(table)
  //       .select()
  //       .eq('uuid', userId)
  //       .order('created_at', ascending: false);

  //   return (response as List)
  //       .map((item) => TransactionModel.fromJson(item))
  //       .toList();
  // }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final response =
        await supabase.rpc('get_transactions_with_category', params: {
      'p_uuid': userId,
    });

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

  Future<void> updateTransaction(TransactionModel transaction, int id) async {
    await supabase.from(table).update(transaction.toJson()).eq('id', id);
  }

Future<void> updateTransactionCategoryOnly({
  required String oldCategoryName,
  required String newCategoryName,
  required String userUuid,
}) async {
  try {
    final response = await supabase
        .from('TRANSACTIONS')
        .update({'category': newCategoryName})
        .eq('category', oldCategoryName)
        .eq('uuid', userUuid);

    print('Update realizado. Resposta: ${response}');
  } catch (e) {
    print('Erro ao atualizar categoria da transação: $e');
    rethrow;
  }
}


  // Subscriptions services
  Future<List<SubscriptionModel>> getSubscription(String userId) async {
    final response = await supabase
        .from("SUBSCRIPTION")
        .select()
        .eq('uuid', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => SubscriptionModel.fromJson(item))
        .toList();
  }

  Future<void> addSubscription(SubscriptionModel model) async {
    await supabase.from('SUBSCRIPTION').insert(model.toJson());
  }

  Future<void> deleteSubscription(int id) async {
    await supabase.from('SUBSCRIPTION').delete().eq('id', id);
  }

  // Saving services
  Future<List<SavingModel>> getSaving(String userId) async {
    final response = await supabase
        .from("SAVING")
        .select()
        .eq('uuid', userId)
        .order('created_at', ascending: true);

    return (response as List)
        .map((item) => SavingModel.fromJson(item))
        .toList();
  }

  Future<SavingModel> addSaving(SavingModel saving) async {
    final response = await supabase
        .from('SAVING')
        .insert({
          'uuid': saving.uuid,
          'title': saving.title,
          'goal_value': saving.goalValue,
          'picture': saving.picture,
          'value': 0,
        })
        .select()
        .single();

    return SavingModel.fromJson(response);
  }

  Future<void> updateSavingValue({
    required int id,
    required double value,
  }) async {
    await supabase.from('SAVING').update({'value': value}).eq('id', id);
  }

  Future<void> deleteSaving(int id) async {
    await supabase.from('SAVING').delete().eq('id', id);
  }

  // Imagens do saving
  Future<List<String>> getImagesSaving() async {
    final response = await supabase.storage.from('saving').list(path: '');

    if (response.isEmpty) return [];

    final urls = response.map((file) {
      return supabase.storage.from('saving').getPublicUrl(file.name);
    }).toList();

    return urls;
  }

  //contas bancarias cadastrado pelo usuario
  Future<List<BanksModel>> getBanks(String userId) async {
    final response = await supabase
        .from("BANKS")
        .select()
        .eq('uuid', userId)
        .order('created_at', ascending: false);

    return (response as List).map((item) => BanksModel.fromJson(item)).toList();
  }

  Future<void> addBanks(BanksModel model) async {
    await supabase.from('BANKS').insert(model.toJson());
  }

  //Cartões criados pelo usuario
  Future<List<MoneyCardModel>> getMoneyCard(String userId) async {
    final response = await supabase
        .from("CARDS")
        .select()
        .eq('uuid', userId)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => MoneyCardModel.fromJson(item))
        .toList();
  }

  Future<void> addMoneyCard(MoneyCardModel model) async {
    await supabase.from('CARDS').insert(model.toJson());
  }

  Future<void> deleteMoneyCard(int id) async {
    await supabase.from('CARDS').delete().eq('id', id);
  }

  Future<void> updateCardOrder(int id, int order) async {
    await supabase
        .from('CARDS') // nome da sua tabela
        .update({'order': order}).eq('id', id);
  }

  // Aqui eu uso apenas no categoriesField para carregar as categorias do banco
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

  Future<void> updateCategoryTransaction(
      CategoryTransactionModel category, int id) async {
    await supabase.from('CATEGORY_TRANSACTIONS').update({
      'name': category.name,
      'color': category.color,
      'type': category.type,
    }).eq('id', id);
  }
}
