import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class OutlineButton extends StatelessWidget {
  final Function() onClick;
  final String? tipo;
  const OutlineButton({
    super.key,
    required this.onClick, required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          onClick();
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: tipo == 'receita' ? AppTheme.greenColor : AppTheme.redColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              tipo == 'receita' ? 'Receita' : 'Despesa',
              style: TextStyle(
                color: tipo == 'receita' ? AppTheme.greenColor : AppTheme.redColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            tipo == 'receita' ? Icon(Iconsax.add_circle, color: AppTheme.greenColor )
            : Icon(Iconsax.minus_cirlce, color: AppTheme.redColor),
          ],
        ),
      ),
    );
  }
}
