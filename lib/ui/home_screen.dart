import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/cards/SavingCard.dart';
import 'package:spendo/components/cards/TotalBalanceCard.dart';
import 'package:spendo/components/HomeBar.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/providers/auth_provider.dart';
import 'package:spendo/utils/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loading = false;
  bool _loadedOnce = false; // controla se já carregou

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserId);
    final transactions = ref.watch(transactionControllerProvider);

    // Escuta mudanças no userId e só executa uma vez
    ref.listen<String?>(currentUserId, (previous, next) {
      if (!_loadedOnce && next != null) {
        _loadedOnce = true;
        loadTransactions(next);
      }
    });

    // Mostra loading até o UUID estar disponível
    if (userId == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: Homebar(),
      drawer: HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SaldoGeralCard(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transações",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.setting_4),
                      )
                    ],
                  ),
                  _loading
                      ? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: AppTheme.primaryColor, size: 64),
                        )
                      : transactions.isEmpty
                          ? Center(
                              child: Text(
                                "Nenhuma transação encontrada",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: transactions.length >= 3
                                  ? 3
                                  : transactions.length,
                              itemBuilder: (context, index) {
                                return TransactionCard(
                                  transaction: transactions[index],
                                );
                              },
                            ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cofrinho",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.setting_4),
                      )
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) => SavingCard(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadTransactions(String userId) async {
    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(transactionControllerProvider.notifier);
    final result = await controller.getTransaction(userId);

    setState(() => _loading = false);
    print("Result: $result");

    if (result != null) {
      print('Erro: $result');
    }
  }
}
