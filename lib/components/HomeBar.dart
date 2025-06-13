import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/ui/main_screen.dart';
import 'package:spendo/utils/theme.dart';

class Homebar extends StatelessWidget implements PreferredSizeWidget {
  Homebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Icon(
          Iconsax.category,
          size: 22,
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
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/104581895?v=4',
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
      backgroundColor: Colors.white,
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
                        onItemSelected?.call(3);
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.wallet_2,
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Cofrinho",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => MainScreen(initialIndex: 3,),
                        // ));
                      },
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: Icon(Iconsax.setting,
                          size: 28, color: AppTheme.primaryColor),
                      title: Text("Configurações",
                          style: const TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (_) => MainScreen(initialIndex: 4)),
                          (route) => false, // remove tudo antes
                        );
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
