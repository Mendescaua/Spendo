import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/providers/theme_provider.dart';
import 'package:spendo/utils/theme.dart';

void showThemeSelectionModal(BuildContext context, WidgetRef ref) {
  final currentTheme = ref.watch(themeModeProvider);
  final themeNotifier = ref.read(themeModeProvider.notifier);

  showModalBottomSheet(
    context: context,
    backgroundColor: Theme.of(context).cardColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        color: AppTheme.dynamicModalColor(context),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Escolha o tema',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: currentTheme,
              title: const Text('Automático (Sistema)'),
              onChanged: (mode) {
                themeNotifier.setTheme(mode!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: currentTheme,
              title: const Text('Claro'),
              onChanged: (mode) {
                themeNotifier.setTheme(mode!);
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: currentTheme,
              title: const Text('Escuro'),
              onChanged: (mode) {
                themeNotifier.setTheme(mode!);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
