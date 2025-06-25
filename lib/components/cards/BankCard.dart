import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class BankCard extends StatelessWidget {
  const BankCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bankcard(
            title: "Banco Santander",
            url:
                "https://www.designtagebuch.de/wp-content/uploads/mediathek/2018/03/santander-logo-icon-743x545.jpg",
          ),
          const SizedBox(height: 16),
          bankcard(
            title: "Carteira",
            url: "",
          ),
          // const Divider(height: 24),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       'Total',
          //       style: TextStyle(
          //         fontSize: 16,
          //       ),
          //     ),
          //     Text(
          //       'R\$ 0,00',
          //       style: TextStyle(
          //         fontSize: 16,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}

class bankcard extends StatelessWidget {
  final String title;
  final String url;

  const bankcard({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFE5E7EB), // fundo cinza claro
            image: url.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(url),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: url.isEmpty
              ? const Icon(Iconsax.wallet,
                  color: Color(0xFF4678C0)) // cor primária
              : null,
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const Text(
              'R\$ 0,00',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
