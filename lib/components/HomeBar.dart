import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/controllers/auth_controller.dart';
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
            radius: 22,
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
  HomeDrawer({Key? key}) : super(key: key);

  @override
  final AuthController _authController = AuthController();
  void logout(BuildContext context) {
    _authController.logout();
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Início'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () {
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}
