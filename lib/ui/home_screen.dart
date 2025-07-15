import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/cards/SavingCard.dart';
import 'package:spendo/components/cards/TotalBalanceCard.dart';
import 'package:spendo/components/cards/TransactionCard.dart';
import 'package:spendo/components/skeletons/skeletonBigCard.dart';
import 'package:spendo/components/skeletons/skeletonCard.dart';
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
    Future.microtask(() async {
      await loadTransactions();
      await loadSavings();
    });
  }

  Future<void> loadTransactions() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final controller = ref.read(transactionControllerProvider.notifier);
    final result = await controller.getTransaction();

    if (!mounted) return;
    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
    }
  }

  Future<void> loadSavings() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final controller = ref.read(savingControllerProvider.notifier);
    final result = await controller.getSaving();

    if (!mounted) return;
    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(
        transactionControllerProvider); // basicamente vc usa isso para ver oque a consulta carregou no provider e reconstruir a tela com os dados carregados

    final savings = ref.watch(savingControllerProvider);
    final filteredSavings =
        savings.where((saving) => saving.value != saving.goalValue).toList();

    return Scaffold(
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
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/transactions'),
                        child: Text(
                          "Transações",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/transactions');
                          },
                          icon: Icon(
                            PhosphorIcons.dotsThreeOutline(
                                PhosphorIconsStyle.regular),
                            size: 26,
                          ))
                    ],
                  ),
                  _loading
                      ? Column(
                          children: List.generate(
                              3, (_) => SkeletonCard(context: context)),
                        )
                      : (() {
                          final now = DateTime.now();
                          final transactionsThisMonth = transactions
                              .where((t) =>
                                  t.date.year == now.year &&
                                  t.date.month == now.month)
                              .toList()
                            ..sort((a, b) => b.date.compareTo(a.date));

                          if (transactionsThisMonth.isEmpty) {
                            return Center(
                              child: Text(
                                "Nenhuma transação encontrada",
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: transactionsThisMonth.length >= 3
                                ? 3
                                : transactionsThisMonth.length,
                            itemBuilder: (context, index) {
                              return TransactionCard(
                                  transaction: transactionsThisMonth[index]);
                            },
                          );
                        })(),
                  Card(
                    color: AppTheme.dynamicCardColor(context),
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    Navigator.of(context).pushNamed('/saving'),
                                child: Row(
                                  children: [
                                    Icon(
                                        PhosphorIcons.handCoins(
                                            PhosphorIconsStyle.regular),
                                        size: 20),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Minhas ",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      "metas",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed('/saving');
                                },
                                icon: Icon(
                                    PhosphorIcons.dotsThreeOutline(
                                        PhosphorIconsStyle.regular),
                                    size: 26),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Card interno (MetaCard)
                          _loading
                              ? Column(
                                  children: List.generate(
                                      3, (_) => SkeletonBigCard(context)),
                                )
                              : savings.isEmpty
                                  ? Center(
                                      child: Text(
                                        "Nenhuma meta encontrado",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : savings == null
                                      ? Column(
                                          children: List.generate(3,
                                              (_) => SkeletonBigCard(context)),
                                        )
                                      : savings.isEmpty
                                          ? const Center(
                                              child: Text(
                                                "Nenhuma meta encontrada",
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  filteredSavings.length >= 2
                                                      ? 2
                                                      : filteredSavings.length,
                                              itemBuilder: (context, index) {
                                                return MetaCard(
                                                    saving:
                                                        filteredSavings[index]);
                                              },
                                            )
                        ],
                      ),
                    ),
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
