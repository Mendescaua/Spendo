import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendo/components/cards/BankHomeCard.dart';
import 'package:spendo/components/cards/SavingCard.dart';
import 'package:spendo/components/cards/TotalBalanceCard.dart';
import 'package:spendo/components/skeletons/skeletonBigCard.dart';
import 'package:spendo/controllers/saving_controller.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/providers/transactions_provider.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loading = false;
  bool _isHidden = false;
  @override
  void initState() {
    super.initState();
    _loadHiddenState();
    Future.microtask(() async {
      setState(() => _loading = true);
      await ref.read(transactionControllerProvider.notifier).getTransaction();
      await ref.read(savingControllerProvider.notifier).getSaving();
      setState(() => _loading = false);
    });
  }

  Future<void> _loadHiddenState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isHidden = prefs.getBool('isSaldoHidden') ?? false;
    });
  }

  Future<void> _toggleHiddenState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isHidden = !_isHidden;
    });
    await prefs.setBool('isSaldoHidden', _isHidden);
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(totalGeralProvider);
    final savings = ref.watch(savingControllerProvider);
    final filteredSavings =
        savings.where((saving) => saving.value != saving.goalValue).toList();

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Parte azul com saldo geral
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saldo geral',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.whiteColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isHidden
                          ? '*********'
                          : (Customtext.formatMoeda(total) ?? 'R\$ 0,00'),
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.whiteColor,
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleHiddenState,
                      icon: Icon(_isHidden ? Iconsax.eye : Iconsax.eye_slash),
                      color: AppTheme.whiteColor,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
          // Parte branca com bordas arredondadas e conteúdo principal
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Cartão de saldo geral
                    SaldoGeralCard(isHidden: _isHidden),

                    /// Cartão de banco
                    BankHomeCard(
                      isHidden: _isHidden,
                    ),

                    /// Cartão de metas
                    Card(
                      color: AppTheme.dynamicCardColor(context),
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .pushNamed('/saving'),
                                  child: Row(
                                    children: [
                                      Icon(
                                        PhosphorIcons.handCoins(
                                            PhosphorIconsStyle.regular),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        "Minhas ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "metas",
                                        style: TextStyle(
                                          fontSize: 16,
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
                                    size: 22,
                                  ),
                                ),
                              ],
                            ),
                            _loading
                                ? Column(
                                    children: List.generate(
                                        2, (_) => SkeletonBigCard(context)),
                                  )
                                : savings.isEmpty
                                    ? Center(
                                        child: Text(
                                          "Nenhuma meta encontrada",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: filteredSavings.length >= 2
                                            ? 2
                                            : filteredSavings.length,
                                        itemBuilder: (context, index) {
                                          return MetaCard(
                                              saving: filteredSavings[index]);
                                        },
                                      )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/chatbot');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: AppTheme.primaryColor,
        child: SizedBox(
          width: 120,
          height: 120,
          child: Lottie.asset(
            'assets/animation/spenai.json',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
