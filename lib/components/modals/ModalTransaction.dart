import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/ui/transaction/new_despesa_screen.dart';
import 'package:spendo/ui/transaction/new_receita_screen.dart';
import 'package:spendo/utils/theme.dart';

class ModalTransaction extends StatelessWidget {
  const ModalTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        height: size.height * 0.38,
        decoration: BoxDecoration(
          color: AppTheme.dynamicModalColor(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 4,
              width: 40,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'O que você quer adicionar?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildOptionButton(
              context: context,
              label: 'Receita',
              icon: PhosphorIcons.trendUp(PhosphorIconsStyle.regular),
              color: Colors.green,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const NewReceitaScreen()));
              },
            ),
            const SizedBox(height: 16),
            _buildOptionButton(
              context: context,
              label: 'Despesa',
              icon: PhosphorIcons.trendDown(PhosphorIconsStyle.regular),
              color: Colors.red,
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (_) => const NewDespesaScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        width: double.infinity,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
