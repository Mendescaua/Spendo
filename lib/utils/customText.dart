import 'dart:ffi';

import 'package:intl/intl.dart';

class Customtext {
  static String formatMoeda(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }
}
