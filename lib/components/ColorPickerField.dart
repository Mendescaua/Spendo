import 'package:flutter/material.dart';

class ColorPickerField extends StatefulWidget {
  final String? initialColorHex;
  final void Function(String colorHex) onColorSelected;

  const ColorPickerField({
    Key? key,
    this.initialColorHex,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<ColorPickerField> createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColorHex != null
        ? _hexToColor(widget.initialColorHex!)
        : Colors.blue; // Cor padrão
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Cor:'),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () async {
            final corEscolhida = await showDialog<Color>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Escolher cor'),
                content: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _coresDisponiveis.map((cor) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context, cor),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: cor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.black12),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );

            if (corEscolhida != null) {
              setState(() {
                _selectedColor = corEscolhida;
              });

              // Converta para string hexadecimal e envie para o callback
              widget.onColorSelected(_colorToHex(_selectedColor));
            }
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  static const List<Color> _coresDisponiveis = [
    // Azuis
    Color(0xFF2196F3), Color(0xFF64B5F6), Color(0xFF0D47A1),
    // Roxos
    Color(0xFF9C27B0), Color(0xFFBA68C8), Color(0xFF4A148C),
    // Verdes
    Color(0xFF4CAF50), Color(0xFF81C784), Color(0xFF1B5E20),
    // Laranjas
    Color(0xFFFF9800), Color(0xFFFFB74D), Color(0xFFE65100),
    // Vermelhos
    Color(0xFFF44336), Color(0xFFE57373), Color(0xFFB71C1C),
    // Aleatórias
    Color(0xFF00BCD4), Color(0xFF607D8B), Color(0xFF795548),
    Color(0xFF00E5FF), Color(0xFF8BC34A), Color(0xFFFF4081),
    Color(0xFFFFC107), Color(0xFF3F51B5), Color(0xFFCDDC39),
    Color(0xFFD4E157), Color(0xFFAA00FF), Color(0xFF263238),
    Color(0xFFFF1744), Color(0xFF1DE9B6), Color(0xFF6200EA),
    Color(0xFF009688), Color(0xFF33691E), Color(0xFFBF360C),
    Color(0xFF3E2723), Color(0xFF000000),
  ];

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // Adiciona opacidade se não houver
    return Color(int.parse(hex, radix: 16));
  }
}
