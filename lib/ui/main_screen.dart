import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/ModalTransaction.dart';
import 'package:spendo/ui/home_screen.dart';
import 'package:spendo/utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  @override
  Widget build(BuildContext context) {
    List screens = [
      HomeScreen(),
      Scaffold(body: Text('Adicionar')),
      Scaffold(body: Text('Adicionar')),
      Scaffold(body: Text('Total gasto')),
      Scaffold(body: Text('Caixinha')),
    ];

    final items = <IconData>[
      Iconsax.home,
      Iconsax.chart_square,
      Iconsax.empty_wallet,
      Iconsax.user,
    ];

    void _openAddTransactionModal(BuildContext context) {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          isScrollControlled: true,
          builder: (context) => ModalTransaction());
    }

    return Scaffold(
      body: screens[currentTab],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppTheme.whiteColor,
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
            // Botão de adicionar (central)
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
            _buildNavIcon(index: 3, icon: items[2]),
            _buildNavIcon(index: 4, icon: items[3]),
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
