import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/ui/components/BankCard.dart';
import 'package:spendo/ui/components/SavingCard.dart';
import 'package:spendo/ui/components/TotalBalanceCard.dart';
import 'package:spendo/ui/components/HomeBar.dart';
import 'package:spendo/ui/components/TransactionCard.dart';
import 'package:spendo/utils/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Homebar(),
      drawer: HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            SaldoGeralCard(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Transações",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.setting_4))
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) => TransactionCard(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Cofrinho",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: Icon(Iconsax.setting_4))
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 2,
                    itemBuilder: (context, index) =>  SavingCard(),
                  ),
                 
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
