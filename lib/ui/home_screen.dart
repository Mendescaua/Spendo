import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/cards/SavingCard.dart';
import 'package:spendo/components/cards/TotalBalanceCard.dart';
import 'package:spendo/components/HomeBar.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/utils/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(transactionControllerProvider.notifier);
    final result = await controller.getTransaction();

    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(
        transactionControllerProvider); // basicamente vc usa isso para ver oque a consulta carregou no provider e reconstruir a tela com os dados carregados
    return Scaffold(
      appBar: Homebar(),
      drawer: HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SaldoGeralCard(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transações",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Iconsax.setting_4))
                    ],
                  ),
                  _loading
                      ? Center(
                          child: (LoadingAnimationWidget.staggeredDotsWave(
                              color: AppTheme.primaryColor, size: 64)))
                      : transactions.isEmpty
                          ? Center(
                              child: Text(
                                "Nenhuma transação encontrada",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: transactions.length >= 3
                                  ? 3
                                  : transactions.length,
                              itemBuilder: (context, index) {
                                return TransactionCard(
                                    transaction: transactions[index]);
                              },
                            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cofrinho",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                          onPressed: () {}, icon: Icon(Iconsax.setting_4))
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
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
}
