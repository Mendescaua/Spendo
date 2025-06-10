import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TransactionContainer extends StatelessWidget {
  final String tipo;

  const TransactionContainer({Key? key, required this.tipo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    IconData iconData;

    switch (tipo) {
      case 'EX':
        backgroundColor = const Color(0xFFFF9669);
        textColor = const Color(0xFF392A00);
        iconData = Icons.error_outline_rounded;
        break;
      case 'AG':
        backgroundColor = const Color(0xFFFFD769);
        textColor = const Color(0xFF392A00);
        iconData = Iconsax.wallet_1;
        break;
      case 'CF':
        backgroundColor = const Color(0xFF87E3AF);
        textColor = const Color(0xFF003A12);
        iconData = Iconsax.car;
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        iconData = Icons.notifications;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Icon(
        iconData,
        color: textColor,
        size: 24,
      ),
    );
  }
}
