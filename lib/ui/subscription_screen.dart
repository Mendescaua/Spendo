import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/MonthPicker.dart';
import 'package:spendo/components/cards/SubscriptionCard.dart';
import 'package:spendo/components/modals/ModalSubscription.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _loading = false;
  DateTime _selectedMonth = DateTime.now();


  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadSubscription());
  }

  Future<void> loadSubscription() async {
    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(subscriptionControllerProvider.notifier);
    final result = await controller.getSubscription();

    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
    }
  }

  void onDelete(int id) async {
    final controller = ref.read(subscriptionControllerProvider.notifier);
    final response = await controller.deleteSubscription(id: id);

    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      FloatingMessage(context, 'Assinatura deletada com sucesso', 'success', 2);
    }
  }

  void _openAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
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
                    child: const ModalSubscription(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final subscription = ref.watch(subscriptionControllerProvider);
    final totalValue =
        ref.watch(subscriptionControllerProvider.notifier).totalValue;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Assinaturas',
          style: TextStyle(color: AppTheme.whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () =>
              Navigator.of(context).pushReplacementNamed('/menu'),
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              Customtext.formatMoeda(totalValue),
              style: const TextStyle(
                color: AppTheme.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration:  BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⬇️ Seletor de Mês aqui dentro do container branco
                  MonthPicker(
                    selectedMonth: _selectedMonth,
                    onMonthChanged: (DateTime newMonth) {
                      setState(() => _selectedMonth = newMonth);
                    },
                  ),
    
                  const SizedBox(height: 24),
                  Expanded(
                    child: _loading
                        ? Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppTheme.primaryColor,
                              size: 64,
                            ),
                          )
                        : subscription.isEmpty
                            ? const Center(
                                child: Text(
                                  "Nenhuma assinatura encontrada",
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                itemCount: subscription.length,
                                itemBuilder: (context, index) {
                                  return Dismissible(
                                    key: Key(
                                        subscription[index].id.toString()),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      return await showDialog<bool>(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Confirmar exclusão'),
                                            content: const Text(
                                                'Você realmente deseja excluir esta assinatura?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(true),
                                                child: const Text(
                                                  'Excluir',
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    background: Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 14, right: 16, top: 2),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(16),
                                      ),
                                      alignment: Alignment.centerRight,
                                      child: const Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                    onDismissed: (direction) {
                                      onDelete(subscription[index].id!);
                                    },
                                    child: SubscriptionCard(
                                        subscription: subscription[index]),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddTransactionModal(context);
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
