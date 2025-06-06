import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class SaldoGeralCard extends StatelessWidget {
  const SaldoGeralCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
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
                'R\$ 0,00',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.whiteColor,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Iconsax.eye_slash),
                color: AppTheme.whiteColor,
              )
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Count(title: 'Receitas', type: 'receita'),
              Count(title: 'Despesas', type: 'despesa'),
            ],
          ),
          const SizedBox(height: 10),
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
        type == 'receita'
            ? Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.transparent, // sem fundo
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        const Color(0xFFE5E7EB), // cor da borda (cinza claro)
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
                            color: AppTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'R\$ 0,00',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.whiteColor),
                        )
                      ],
                    )
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.transparent, // sem fundo
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color:
                        const Color(0xFFE5E7EB), // cor da borda (cinza claro)
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
                            color: AppTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'R\$ 0,00',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.whiteColor),
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
