import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4678c0);
  static const Color secondaryColor = Color(0xFF252627);
  static const Color backgroundColor= Color.fromARGB(255, 246, 247, 248);
  static const Color textColor = Color(0xFF000000);
  static const Color shadowTextColor = Color.fromARGB(122, 0, 0, 0);
  static const Color whiteColor = Color(0xFFFFFFFF);

  static const Color redColor = Color(0xFFB00020);
  static const Color greenColor = Color(0xFF22C55E);
  static const Color softRedColor = Color.fromARGB(255, 253, 232, 232);
  static const Color softGreenColor = Color(0xFFD1FAE5);

  static ThemeData get appTheme {
    return ThemeData(
      fontFamily: 'Poppins',
      primaryColor: primaryColor,
      focusColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      secondaryHeaderColor: secondaryColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        titleTextStyle: const TextStyle(
          color: whiteColor,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        onPrimary: whiteColor,
        surface: whiteColor,
        onSurface: textColor,
        brightness: Brightness.light,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        labelStyle: TextStyle(color: primaryColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: whiteColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(primaryColor),
        trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(primaryColor),
      ),
    );
  }
}
