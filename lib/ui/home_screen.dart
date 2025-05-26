import 'package:flutter/material.dart';
import 'package:spendo/ui/components/BankCard.dart';
import 'package:spendo/ui/components/TotalBalanceCard.dart';
import 'package:spendo/ui/components/HomeBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Homebar(),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SaldoGeralCard(),
            Text(
              "Contas",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            BankCard()
          ],
        ),
      )),
    );
  }
}
