import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/cards/SavingCard.dart';
import 'package:spendo/components/cards/TotalBalanceCard.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/controllers/saving_controller.dart';
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
    Future.microtask(() => loadAllData());
  }

  Future<void> loadAllData() async {
    setState(() => _loading = true);

    await Future.delayed(Duration(seconds: 8));


    final transactionController =
        ref.read(transactionControllerProvider.notifier);
    final savingController = ref.read(savingControllerProvider.notifier);

    final transactionResult = await transactionController.getTransaction();
    final savingResult = await savingController.getSaving();

    setState(() => _loading = false);

    if (transactionResult != null) {
      print('Erro transações: $transactionResult');
    }

    if (savingResult != null) {
      print('Erro cofrinho: $savingResult');
    }
  }
@override
Widget build(BuildContext context) {
  final transactions = ref.watch(transactionControllerProvider);
  final savings = ref.watch(savingControllerProvider);

  return Scaffold(
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SaldoGeralCard(),
          const SizedBox(height: 16),

          // Se estiver carregando, mostra o loader abaixo do saldo
          if (_loading)
            Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: AppTheme.primaryColor,
                size: 64,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  /// Transações
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
                      ),
                    ],
                  ),
                  transactions.isEmpty
                      ? Center(
                          child: Text(
                            "Nenhuma transação encontrada",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              transactions.length >= 3 ? 3 : transactions.length,
                          itemBuilder: (context, index) {
                            return TransactionCard(
                              transaction: transactions[index],
                            );
                          },
                        ),

                  const SizedBox(height: 16),

                  /// Cofrinho
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
                      ),
                    ],
                  ),
                  savings.isEmpty
                      ? Center(
                          child: Text(
                            "Nenhum cofrinho encontrado",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              savings.length >= 3 ? 3 : savings.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed('/saving');
                              },
                              child: SavingCard(
                                saving: savings[index],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}
}