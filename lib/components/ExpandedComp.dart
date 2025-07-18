import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';

class Expandedcomp extends StatefulWidget {
  final void Function(int quantidade)? onRepetirChanged;

  const Expandedcomp({
    super.key,
    this.onRepetirChanged,
  });

  @override
  State<Expandedcomp> createState() => _ExpandedcompState();
}

class _ExpandedcompState extends State<Expandedcomp> {
  bool mostrar = false;
  bool repetir = false;
  int repetirQuantidade = 1;

  void _abrirBottomSheetRepeticoes() async {
    int tempQuantidade = repetirQuantidade;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: AppTheme.dynamicModalColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(16).copyWith(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Em quantas vezes deseja repetir?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField2<int>(
                value: tempQuantidade,
                isExpanded: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.repeat),
                  hintText: 'Selecione a quantidade',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppTheme.dynamicTextColor(context),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppTheme.dynamicTextColor(context),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: AppTheme.dynamicTextColor(context),
                      width: 2,
                    ),
                  ),
                ),
                buttonStyleData: const ButtonStyleData(
                  padding: EdgeInsets.only(right: 8),
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 48.0 * 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 24,
                ),
                items: List.generate(12, (index) {
                  final value = index + 1;
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  );
                }),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      repetirQuantidade = value;
                    });
                    widget.onRepetirChanged?.call(repetirQuantidade);
                    Navigator.pop(context);
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget buildToggleBox({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    String? subtitle,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.dynamicBackgroundColor(context),
          border: Border.all(
            color: isActive
                ? AppTheme.dynamicTextColor(context)
                : Colors.grey.shade400,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isActive ? AppTheme.primaryColor : Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.dynamicTextColor(context),
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mostrar) ...[
          buildToggleBox(
            label: 'Repetir',
            isActive: repetir,
            subtitle: repetir ? 'Repetir por $repetirQuantidade meses' : null,
            onTap: () {
              setState(() {
                repetir = !repetir;
                if (repetir) _abrirBottomSheetRepeticoes();
              });
            },
          ),
        ],
        if (!mostrar)
          GestureDetector(
            onTap: () {
              setState(() {
                mostrar = true;
              });
            },
            child: const Text(
              'Mais detalhes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}
