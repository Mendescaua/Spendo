import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Customtext {
  static String formatMoeda(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  static String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
  }

  static Color stringToColor(String colorString) {
  // Remove o "#" se existir
  colorString = colorString.replaceAll("#", "");

  // Se tiver apenas 6 caracteres (sem alpha), adiciona FF (totalmente opaco)
  if (colorString.length == 6) {
    colorString = "FF$colorString";
  }

  // Converte para Color
  return Color(int.parse(colorString, radix: 16));
}

}
