import 'package:flutter/material.dart';
import 'package:spendo/ui/components/SaldoGeralCard.dart';
import 'package:spendo/ui/components/HomeBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Homebar(),
      
      body: SafeArea(
        child: Column(children: [
          SaldoGeralCard(),
        ],)
      ),
    );
  }
}