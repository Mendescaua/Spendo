import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/providers/theme_provider.dart';
import 'package:spendo/utils/theme.dart';

void showThemeSelectionModal(BuildContext context, WidgetRef ref) {
  final currentTheme = ref.watch(themeModeProvider);
  final themeNotifier = ref.read(themeModeProvider.notifier);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.dynamicModalColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 4, width: 40, margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(2)),
              ),
              const Text('Escolha o tema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              AnimatedToggleSwitch<ThemeMode>.rolling(
                current: currentTheme,
                values: const [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
                onChanged: (mode) {
                  themeNotifier.setTheme(mode);
                  Navigator.pop(context);
                },
                iconBuilder: (mode, selected) {
                  final icon = mode == ThemeMode.light
                      ? Iconsax.sun_1
                      : mode == ThemeMode.dark
                          ? Iconsax.moon
                          : Iconsax.magic_star;
                  return Icon(icon, size: 24, color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color);
                },
                style: ToggleStyle(
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  borderColor: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  indicatorColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
                height: 60,
                spacing: 8.0,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );
    },
  );
}
