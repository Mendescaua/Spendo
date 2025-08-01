import 'package:flutter/material.dart';
import 'package:spendo/ui/main_screen.dart';

class BackToHomeWrapper extends StatelessWidget {
  final Widget child;

  const BackToHomeWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Redireciona para a Home ao invés de fechar o app
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainScreen(),
          ),
        );
        return false;
      },
      child: child,
    );
  }
}
