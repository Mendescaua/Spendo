import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:spendo/utils/theme.dart';

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
      monthPickerDialogSettings: MonthPickerDialogSettings(
        dialogSettings: PickerDialogSettings(dialogRoundedCornersRadius: 20),
        dateButtonsSettings: PickerDateButtonsSettings(
          monthTextStyle: const TextStyle(
            color: Colors.black, // Texto dos meses
            fontSize: 16,
          ),
          currentMonthTextColor: AppTheme.dynamicTextColor(context),
          selectedMonthTextColor: Colors.white,
          unselectedMonthsTextColor: AppTheme.dynamicTextColor(context),
        ),
        actionBarSettings: PickerActionBarSettings(
          cancelWidget: Text('Cancelar', style: TextStyle(color: AppTheme.dynamicTextColor(context))),
          confirmWidget: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: const Text(
              'Filtrar',
              style: TextStyle(
                color: AppTheme.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: textColor),
        ],
      ),
    );
  }
}
