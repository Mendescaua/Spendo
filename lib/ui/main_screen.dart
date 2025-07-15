import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/HomeBar.dart';
import 'package:spendo/components/modals/ModalTransaction.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/controllers/user_controller.dart';
import 'package:spendo/ui/configuration_screen.dart';
import 'package:spendo/ui/home_screen.dart';
import 'package:spendo/ui/saving/saving_screen.dart';
import 'package:spendo/ui/subscription_screen.dart';
import 'package:spendo/ui/transactionChart/transaction_chart_tab.dart';
import 'package:spendo/ui/wallet/wallet_screen.dart';
import 'package:spendo/utils/theme.dart';

class MainScreen extends ConsumerStatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    currentTab = widget.initialIndex;
    Future.microtask(() {
      ref.read(userControllerProvider.notifier).getUser();
      ref.read(bankControllerProvider.notifier).getBank();
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const HomeScreen(),
      TransactionChartTab(),
      WalletScreen(),
      const SubscriptionScreen(),
      const SavingScreen(),
      const ConfiguracoesScreen(),
    ];

    final items = <IconData>[
      Iconsax.home,
      Iconsax.chart_square,
      Iconsax.empty_wallet,
      Iconsax.setting,
    ];

    
  void _openMenuModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => HomeMenuModal(
        onItemSelected: (index) {
          setState(() {
            currentTab = index;
          });
          Navigator.of(context).pop(); // fecha o modal
        },
      ),
    );
  }

    void _openAddTransactionModal(BuildContext context) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        isScrollControlled: true,
        builder: (context) => const ModalTransaction(),
      );
    }

    return Scaffold(
      appBar: currentTab == 0 
          ? Homebar(
              onItemSelected: (index) {
                setState(() {
                  currentTab = index;
                });
              },
            )
          : null,
          
      // drawer: HomeDrawer(
      //   onItemSelected: (index) {
      //     setState(() {
      //       currentTab = index;
      //     });
      //   },
      // ),
      body: screens[currentTab],
      bottomNavigationBar: currentTab == 3 || currentTab == 4
          ? null
          : Container(
              height: 90,
              padding: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppTheme.dynamicNavBarColor(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavIcon(index: 0, icon: items[0]),
                  _buildNavIcon(index: 1, icon: items[1]),
                  GestureDetector(
                    onTap: () => _openAddTransactionModal(context),
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Iconsax.add,
                          color: AppTheme.whiteColor, size: 30),
                    ),
                  ),
                  _buildNavIcon(index: 2, icon: items[2]),
                  _buildNavIcon(index: 5, icon: items[3]),
                ],
              ),
            ),
    );
  }

  Widget _buildNavIcon({required int index, required IconData icon}) {
    final isSelected = currentTab == index;

    return GestureDetector(
      onTap: () => setState(() => currentTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        padding: const EdgeInsets.all(8),
        child: Transform.scale(
          scale: isSelected ? 1.2 : 1.0,
          child: Icon(
            icon,
            size: 28,
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
