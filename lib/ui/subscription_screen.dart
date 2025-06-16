import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/cards/SubscriptionCard.dart';
import 'package:spendo/components/modals/ModalSubscription.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/utils/theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _loading = false;

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
    print("Result: $result");

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
            onTap: () => Navigator.of(context).pop(), // toca fora = fecha
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  // impede que toques dentro do modal fechem
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
        body: GestureDetector(
          child: SafeArea(
            child: Column(
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

                // TextField sem borda nenhuma
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'R\$ 0,00',
                          style: TextStyle(
                              color: AppTheme.whiteColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: () {
                              _openAddTransactionModal(context);
                            },
                            icon: Icon(
                              Iconsax.add,
                              color: Colors.white,
                              size: 32,
                            ))
                      ],
                    )),

                const SizedBox(height: 32),

                // Container branco ocupando toda a largura
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          _loading
                              ? Center(
                                  child:
                                      (LoadingAnimationWidget.staggeredDotsWave(
                                          color: AppTheme.primaryColor,
                                          size: 64)))
                              : subscription.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Nenhuma assinatura encontrada",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: subscription.length >= 3
                                          ? 3
                                          : subscription.length,
                                      itemBuilder: (context, index) {
                                        return SubscriptionCard(
                                            subscription: subscription[index]);
                                      },
                                    ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
