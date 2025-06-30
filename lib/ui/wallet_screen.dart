import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/BankCard.dart';
import 'package:spendo/components/cards/MoneyCard.dart';
import 'package:spendo/components/modals/ModalBank.dart';
import 'package:spendo/controllers/money_card_controller.dart';
import 'package:spendo/utils/theme.dart';

class WalletScreen extends ConsumerStatefulWidget {
  WalletScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadCards());
  }

  Future<void> loadCards() async {
    // Verifica se já está carregando ou se as transações já foram carregadas
    // para evitar consultas desnecessárias toda vez que a tela for aberta.
    final currentTransactions = ref.read(moneyCardControllerProvider);
    if (_loading || currentTransactions.isNotEmpty) return;

    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(moneyCardControllerProvider.notifier);
    final result = await controller.getMoneyCard();

    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
    }
  }

  void _openAddTransactionModal(BuildContext context) async {
    final result = await showModalBottomSheet(
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
                    child: const ModalBank(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (result == true) {
      FloatingMessage(
          context, 'Conta bancária adicionada com sucesso', 'success', 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(moneyCardControllerProvider);
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        title: const Text(
          'Minha Carteira',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cartões
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Cartões",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/money_card');
                        },
                        icon: Icon(Iconsax.add,
                            color: AppTheme.primaryColor, size: 26),
                      ),
                    ],
                  ),
                  _loading
                      ? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                            color: AppTheme.primaryColor,
                            size: 64,
                          ),
                        )
                      : cards.isEmpty
                          ? const Center(
                              child: Text(
                                "Nenhum cartão encontrado",
                                style: TextStyle(fontSize: 16),
                              ),
                            )
                          : SizedBox(
                              height: 170,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: cards.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.only(
                                      right: index == cards.length - 1
                                          ? 0
                                          : 16), // espaçamento só entre os cards, sem no último
                                  child: MoneyCard(cards: cards[index]),
                                ),
                              ),
                            ),

                  const SizedBox(height: 16),
                  // Contas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Contas",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {
                          _openAddTransactionModal(context);
                        },
                        icon: Icon(Iconsax.add,
                            color: AppTheme.primaryColor, size: 26),
                      ),
                    ],
                  ),
                  BankCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
