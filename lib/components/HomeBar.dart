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
        onPressed: () => Scaffold.of(context).openDrawer(),
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

class HomeDrawer extends StatelessWidget {
  final void Function(int)? onItemSelected;
  const HomeDrawer({super.key, this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Expanded(
                    child: Text(
                      'Menu',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Removido ToggleButtons
                ],
              ),
            ),
            const Divider(),
            // CONTENT
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Categorias'),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.home,
                          size: 28, color: AppTheme.primaryColor),
                      title:
                          Text("Inicio", style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.chart_square,
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Gráficos",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected?.call(1);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.empty_wallet,
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Carteira",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected?.call(2);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.card,
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Assinaturas",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected?.call(3);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Minhas metas",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected?.call(4);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.setting,
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Configurações",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pop();
                        onItemSelected?.call(5);
                      },
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }
}
