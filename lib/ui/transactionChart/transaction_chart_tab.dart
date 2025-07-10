import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/ui/transactionChart/category_chart.dart';
import 'package:spendo/ui/transactionChart/transaction_chart.dart';
import 'package:spendo/utils/theme.dart';

class TransactionChartTab extends ConsumerStatefulWidget {
  const TransactionChartTab({super.key});

  @override
  ConsumerState<TransactionChartTab> createState() =>
      _TransactionChartTabState();
}

class _TransactionChartTabState extends ConsumerState<TransactionChartTab> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> tabContents = [
      const CategoryChart(),
      const IncomeExpenseBarChart(),
      const Center(
          child: Text(
        "Estatísticas",
      )),
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: const Text(
          'Relatórios',
          style: TextStyle(color: AppTheme.whiteColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.whiteColor),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TabNavigation(
              selectedIndex: _currentIndex,
              onTabSelected: _onTabSelected,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: IndexedStack(
                index: _currentIndex,
                children: tabContents,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class TabNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const TabNavigation({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [PhosphorIcons.chartDonut(PhosphorIconsStyle.regular), PhosphorIcons.chartBar(PhosphorIconsStyle.regular), Icons.bar_chart];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.dynamicBackgroundColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icons[index],
                size: 32,
                color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor,
              ),
            ),
          );
        }),
      ),
    );
  }
}
