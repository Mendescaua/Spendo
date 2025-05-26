import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class Homebar extends StatelessWidget implements PreferredSizeWidget {
  Homebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(
              'https://avatars.githubusercontent.com/u/104581895?v=4',
            ),
          ),
          SizedBox(width: 12),
          Text(
            "Cauã",
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Handle settings button press
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
