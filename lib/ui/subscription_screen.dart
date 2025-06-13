import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/cards/SubscriptionCard.dart';
import 'package:spendo/components/modals/ModalSubscription.dart';
import 'package:spendo/utils/theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  void _openAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Material(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: ModalSubscription(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return const SubscriptionCard();
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
