import 'package:flutter/material.dart';

class AppTheme {
  // Cores fixas
  static const Color primaryColor = Color(0xFF4678c0);
  static const Color secondaryColor = Color(0xFF252627);
  static const Color backgroundColor = Color(0xFFF6F7F8);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color darkBackgroundColor = Color(0xFF272727);

  static const Color textColor = Color(0xFF000000);
  static const Color darkTextColor = Color(0xFFFFFFFF);

  static const Color redColor = Color(0xFFB00020);
  static const Color greenColor = Color(0xFF22C55E);
  static const Color softRedColor = Color(0xFFFDE8E8);
  static const Color softGreenColor = Color(0xFFD1FAE5);
  static const Color isArchivedColor = Color(0xFFFDE8E8);
  static const Color notArchivedColor = Color(0xFFD1FAE5);

  /// Retorna a cor "white" baseada no tema atual (claro ou escuro)
  static Color dynamicBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF272727) // white adaptado para dark
        : Color(0xFFF6F7F8); // branco real para light
  }

  static Color dynamicNavBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF242424) // white adaptado para dark
        : Color(0xFFFFFFFF); // branco real para light
  }

  static Color dynamicCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2E2E2E) // white adaptado para dark
        : Color(0xFFFFFFFF); // branco real para light
  }

  static Color dynamicTextFieldColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 54, 54, 54) // white adaptado para dark
        : Color(0xFFFFFFFF); // branco real para light
  }

  static Color dynamicModalColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2E2E2E) // Modal mais claro no dark
        : Color(0xFFF6F7F8); // Normal no light
  }

  /// Exemplo: dynamic text color
  static Color dynamicTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextColor
        : textColor;
  }

  static Color dynamicRedColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFFF6161)
        : redColor;
  }

  static Color dynamicDespesaColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFAC1934)
        : const Color(0xFFAC1934);
  }

  static Color dynamicDespesaSoftColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 56, 30, 30)// AppTheme.softRedColor const Color(0xFFf23654)
        : AppTheme.softRedColor ;
  }

  static Color dynamicDespesaTotalColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFFf23654)
        : redColor ;
  }

  static Color dynamicReceitaSoftColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF16352d)// AppTheme.softRedColor const Color(0xFFf23654)
        : AppTheme.softGreenColor  ;
  }

  static Color dynamicReceitaTotalColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2bc279)
        : AppTheme.greenColor ;
  }

  static Color dynamicReceitaColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF029456)
        : const Color(0xFF029456);
  }

  static Color dynamicBorderSavingColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color.fromARGB(255, 32, 32, 32)
        : Colors.grey.shade300;
  }

  static Color dynamicSkeletonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2E2E2E) // white adaptado para dark
        : Colors.grey.shade300; // branco real para light
  }

  static Color dynamicIconColor(Color backgroundColor) {
    return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: primaryColor,
          background: backgroundColor,
          onPrimary: Colors.white,
          onSurface: textColor,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        primaryColor: primaryColor,
        scaffoldBackgroundColor: darkBackgroundColor,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: primaryColor,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          secondary: primaryColor,
          background: darkBackgroundColor,
          onPrimary: Colors.white,
          onSurface: darkTextColor,
        ),
      );
}
