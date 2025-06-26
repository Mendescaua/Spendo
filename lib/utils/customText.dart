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
  if (colorString == null || colorString.isEmpty) {
    // Retorna uma cor padrão, por exemplo transparente, para evitar erro
    return Colors.transparent;
  }
  
  colorString = colorString.replaceAll("#", "").toUpperCase();
  
  if (colorString.length == 6) {
    // Se tiver só RRGGBB, adiciona FF para alfa full opacity
    colorString = "FF$colorString";
  } else if (colorString.length != 8) {
    // Se tiver tamanho inválido, também pode retornar transparente ou lançar erro
    return Colors.transparent;
  }
  
  return Color(int.parse("0x$colorString"));
}


}
