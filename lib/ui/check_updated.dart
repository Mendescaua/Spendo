import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:spendo/utils/theme.dart';

class CheckForUpdate extends StatefulWidget {
  final Widget child;

  const CheckForUpdate({super.key, required this.child});

  @override
  _CheckForUpdateState createState() => _CheckForUpdateState();
}

class _CheckForUpdateState extends State<CheckForUpdate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate();
    });
  }

  Future<void> checkForUpdate() async {
    try {
      var info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        _showUpdateDialog();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Atualização Disponível'),
        content: const Text(
            'Uma nova versão do app está disponível. Deseja atualizar agora?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // fecha o dialog
            },
            child: const Text('Depois'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              update();
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: const Text(
                'Atualizar',
                style: TextStyle(
                  color: AppTheme.whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void update() async {
    try {
      await InAppUpdate.startFlexibleUpdate();
      await InAppUpdate.completeFlexibleUpdate();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
