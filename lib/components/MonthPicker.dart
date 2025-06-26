import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class MonthPicker extends StatelessWidget {
  final DateTime selectedMonth;
  final Function(DateTime) onMonthChanged;

  const MonthPicker({
    super.key,
    required this.selectedMonth,
    required this.onMonthChanged,
  });

  Future<void> _showMonthPicker(BuildContext context) async {
    final picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (picked != null) {
      onMonthChanged(DateTime(picked.year, picked.month));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMonthPicker(context),
      child: Row(
        children: [
          Text(
            toBeginningOfSentenceCase(
                  DateFormat.MMMM('pt_BR').format(selectedMonth),
                ) ??
                '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
