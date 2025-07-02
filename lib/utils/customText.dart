import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Customtext {
  static String formatMoeda(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  static String limitarDescricao(String texto, [int limite = 22]) {
    if (texto.length <= limite) return texto;
    return texto.substring(0, limite).trim() + '...';
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

 static String formatarDataHora(DateTime data) {
  // Nome do dia da semana em pt_BR (ex: segunda)
  final diaSemana = DateFormat.EEEE('pt_BR').format(data);
  // Formata a data e hora
  final dataHora = DateFormat('dd/MM/yyyy \'às\' HH:mm', 'pt_BR').format(data);
  // Combina tudo com inicial minúscula
  return '${capitalizeFirstLetter(diaSemana)}, $dataHora';
}

  // ex: 02 JUL
  static String formatarData(dynamic data) {
    try {
      DateTime? date;

      // Se já for DateTime
      if (data is DateTime) {
        date = data;
      }
      // Se for String
      else if (data is String) {
        List<String> formatos = [
          "yyyy-MM-dd",
          "dd/MM/yyyy",
          "MM/dd/yyyy",
          "yyyy-MM-ddTHH:mm:ss",
          "yyyy-MM-dd HH:mm:ss",
          "dd-MM-yyyy",
        ];

        for (var formato in formatos) {
          try {
            date = DateFormat(formato).parseStrict(data);
            break;
          } catch (_) {}
        }

        date ??= DateTime.tryParse(data);
      }

      if (date != null) {
        String formatado = DateFormat("dd MMM", 'pt_BR').format(date);
        formatado = formatado
            .replaceAll('.', '')
            .toUpperCase(); // Remove ponto e coloca em maiúsculo
        return formatado;
      } else {
        return "DATA INVÁLIDA";
      }
    } catch (e) {
      return "DATA INVÁLIDA";
    }
  }
}
