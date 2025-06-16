import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/SubscriptionCard.dart';
import 'package:spendo/components/modals/ModalSubscription.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
    Future.microtask(() => loadTransactions());
  }

  Future<void> loadTransactions() async {
    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(subscriptionControllerProvider.notifier);
    final result = await controller.getSubscription();

    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
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

  Future<void> _showMonthPicker(BuildContext context) async {
    final picked = await showMonthYearPicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      setState(() {
        _selectedMonth = DateTime(picked.year, picked.month);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptions = ref.watch(subscriptionControllerProvider);
    final totalValue =
        ref.watch(subscriptionControllerProvider.notifier).totalValue;

    void onDelete(int id) async {
      final controller = ref.read(subscriptionControllerProvider.notifier);
      final response = await controller.deleteSubscription(id: id);

      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(
            context, 'Assinatura deletada com sucesso', 'success', 2);
      }
    }

    final subscription = subscriptions.where((s) {
      final createdAt = s.createdAt;
      return createdAt?.month == _selectedMonth.month &&
          createdAt?.year == _selectedMonth.year;
    }).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Assinaturas',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Customtext.formatMoeda(totalValue),
                    style: const TextStyle(
                      color: AppTheme.whiteColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _openAddTransactionModal(context);
                    },
                    icon: const Icon(
                      Iconsax.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ⬇️ Seletor de Mês aqui dentro do container branco
                    GestureDetector(
                      onTap: () => _showMonthPicker(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            toBeginningOfSentenceCase(DateFormat.MMMM('pt_BR')
                                    .format(_selectedMonth)) ??
                                '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
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
                                      background: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical:
                                                8), // mesmo espaçamento do card
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                              16), // igual ao do seu SubscriptionCard
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
      ),
    );
  }
}
