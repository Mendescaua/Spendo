import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF003366);
  static const Color secondaryColor = Color(0xFF222932);
  static const Color textColor = Color(0xFF000000);



  // Tema Claro
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  // Tema Escuro
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryColor,
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: Colors.white70),
    ),
  );
}
