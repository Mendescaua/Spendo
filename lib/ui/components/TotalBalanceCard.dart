import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class SaldoGeralCard extends StatelessWidget {
  const SaldoGeralCard({super.key});

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
          Text(
            'Saldo geral',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'R\$ 0,00',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Iconsax.eye_slash,
              ),
            ],
          ),
          const Divider(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Count(title: 'Receitas', type: 'receita'),
              Count(title: 'Despesas', type: 'despesa'),
            ],
          ),
          
        ],
      ),
    );
  }
}

class Count extends StatelessWidget {
  final String title;
  final String type;
  const Count({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        type == 'receita' ? Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent, // sem fundo
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB), // cor da borda (cinza claro)
              width: 1, // espessura da borda
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.softGreenColor, // verde claro
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.money,
                  color: AppTheme.greenColor, // verde
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'R\$ 0,00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ) :
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.transparent, // sem fundo
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE5E7EB), // cor da borda (cinza claro)
              width: 1, // espessura da borda
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.softRedColor, // vermelho claro
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Iconsax.money,
                  color: AppTheme.redColor, // vermelho
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'R\$ 0,00',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              )
            ],
          ),
        ) 

      ],
    );
  }
}
