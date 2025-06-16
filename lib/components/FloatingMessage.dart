import 'package:flutter/material.dart';

void FloatingMessage(BuildContext context, String message, String type, int duration) {
  final messenger = ScaffoldMessenger.maybeOf(context) ?? ScaffoldMessenger.of(
    Navigator.of(context, rootNavigator: true).context,
  );

  Color backgroundColor;
  Color textColor;
  IconData iconData;

  switch (type) {
    case 'error':
      backgroundColor = Color(0xFFFFCDCD);
      textColor = Color(0xFF580707);
      iconData = Icons.error_outline_rounded;
      break;
    case 'info':
      backgroundColor = Color(0xFFF4F3D2);
      textColor = Color(0xFF584207);
      iconData = Icons.info_outline_rounded;
      break;
    case 'success':
      backgroundColor = Color(0xFFCCECDA);
      textColor = Color(0xFF0B7B2D);
      iconData = Icons.check_circle_outline_rounded;
      break;
    default:
      backgroundColor = Colors.grey;
      textColor = Colors.white;
      iconData = Icons.notifications;
  }

  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: textColor),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              textScaleFactor: 1.0,
              message,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(20),
      elevation: 0,
      duration: Duration(seconds: duration),
    ),
  );
}
