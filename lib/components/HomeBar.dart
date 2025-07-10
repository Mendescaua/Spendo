import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/controllers/user_controller.dart';
import 'package:spendo/utils/base64.dart';
import 'package:spendo/utils/theme.dart';

class Homebar extends ConsumerWidget implements PreferredSizeWidget {
  final void Function(int)? onItemSelected;
  Homebar({Key? key, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(userControllerProvider).firstOrNull;
    return AppBar(
      centerTitle: true,
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => HomeMenuModal(onItemSelected: onItemSelected),
          );
        },
        icon: Icon(
          Iconsax.category,
          size: 26,
          color: AppTheme.whiteColor,
        ),
      ),
      title: Text(
        "Home",
        style: TextStyle(
          fontSize: 18,
          color: AppTheme.whiteColor,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: GestureDetector(
            onTap: () {
              onItemSelected?.call(5);
            },
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade200,
              backgroundImage:
                  users?.picture != null && users!.picture!.isNotEmpty
                      ? base64ToImage(users.picture!)
                      : null,
              child: users?.picture == null || users!.picture!.isEmpty
                  ? Text(
                      (users?.name.isNotEmpty ?? false)
                          ? users!.name[0].toUpperCase()
                          : '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class HomeMenuModal extends StatelessWidget {
  final void Function(int)? onItemSelected;
  const HomeMenuModal({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    // Lista de opções para mapear
    final items = [
      {
        'id': 0,
        'icon': Iconsax.home,
        'label': 'Início',
      },
      {
        'id': 1,
        'icon': Iconsax.chart_square,
        'label': 'Gráficos',
      },
      {
        'id': 2,
        'icon': Iconsax.empty_wallet,
        'label': 'Carteira',
      },
      {
        'id': 3,
        'icon': Iconsax.card,
        'label': 'Assinaturas',
      },
      {
        'id': 4,
        'icon': PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
        'label': 'Minhas metas',
      },
      {
        'id': 5,
        'icon': Iconsax.setting,
        'label': 'Configurações',
      },
    ];

   return SafeArea(
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
    decoration: BoxDecoration(
      color: AppTheme.dynamicBackgroundColor(context),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 4,
          width: 40,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const Text(
          'Menu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: items.map((item) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                if (onItemSelected != null) {
                  onItemSelected!(item['id'] as int);
                }
              },
              child: Container(
                width: (MediaQuery.of(context).size.width - 64) / 3,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Ícone no topo esquerdo
                    item.containsKey('icon')
                        ? Icon(
                            item['icon'] as IconData,
                            size: 24,
                            color: AppTheme.primaryColor,
                          )
                        : SizedBox(
                            width: 24,
                            height: 24,
                            child: item['iconWidget'] as Widget,
                          ),

                    // Texto embaixo à esquerda
                    Text(
                      item['label'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 32),
      ],
    ),
  ),
);
  }
}
