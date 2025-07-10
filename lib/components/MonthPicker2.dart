import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class Monthpicker2 extends StatelessWidget {
  final DateTime? selectedMonth;
  final void Function(DateTime?) onMonthSelected;
  final String? hintText;
  final Color textColor;

  const Monthpicker2({
    Key? key,
    required this.selectedMonth,
    required this.onMonthSelected,
    this.hintText,
    this.textColor = Colors.white,
  }) : super(key: key);

  String get displayText {
    if (selectedMonth == null) return hintText ?? 'Todos os meses';
    return toBeginningOfSentenceCase(
          DateFormat('MMMM', 'pt_BR').format(selectedMonth!),
        ) ??
        '';
  }

  Future<void> _pickMonth(BuildContext context) async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: selectedMonth ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null) {
      onMonthSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickMonth(context),
      child: Row(
        children: [
          Text(
            displayText,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, color: textColor),
        ],
      ),
    );
  }
}
