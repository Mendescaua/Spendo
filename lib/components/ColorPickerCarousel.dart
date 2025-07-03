import 'package:flutter/material.dart';

class ColorPickerCarousel extends StatefulWidget {
  final String? initialColorHex;
  final void Function(String colorHex) onColorSelected;

  const ColorPickerCarousel({
    Key? key,
    this.initialColorHex,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  State<ColorPickerCarousel> createState() => _ColorPickerCarouselState();
}

class _ColorPickerCarouselState extends State<ColorPickerCarousel> {
  late Color _selectedColor;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColorHex != null
        ? _hexToColor(widget.initialColorHex!)
        : Colors.blue;

    // Aguarda o frame construir antes de tentar rolar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedColor();
    });
  }

  void _scrollToSelectedColor() {
    final index = _coresDisponiveis.indexWhere((c) => c.value == _selectedColor.value);
    if (index != -1) {
      // Calcula a posição de rolagem baseada na largura dos itens (incluindo espaçamento)
      final double itemWidth = 36 + 12; // largura do item + separador
      final double scrollPosition = itemWidth * index;
      _scrollController.animateTo(
        scrollPosition,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cor:'),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView.separated(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _coresDisponiveis.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cor = _coresDisponiveis[index];
              final isSelected = cor.value == _selectedColor.value;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = cor;
                  });
                  widget.onColorSelected(_colorToHex(_selectedColor));
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.black : Colors.grey,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 18)
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  static const List<Color> _coresDisponiveis = [ 
    // Azuis
    Color(0xFF4678C0), Color(0xFF63A4FF), Color(0xFF1976D2), Color(0xFF2196F3),
    Color(0xFF1E88E5),
    Color(0xFF42A5F5), Color(0xFF90CAF9), Color(0xFFBBDEFB), Color(0xFF0D47A1),
    Color(0xFF1565C0),

    // Verdes
    Color(0xFF4CAF50), Color(0xFF81C784), Color(0xFF2E7D32), Color(0xFF66BB6A),
    Color(0xFF00C853),
    Color(0xFF1B5E20), Color(0xFFA5D6A7), Color(0xFFC8E6C9), Color(0xFF388E3C),
    Color(0xFF43A047),

    // Vermelhos / Rosas
    Color(0xFFE53935), Color(0xFFFF5252), Color(0xFFEF5350), Color(0xFFFF8A80),
    Color(0xFFD32F2F),
    Color(0xFFF44336), Color(0xFFB71C1C), Color(0xFFE57373), Color(0xFFFFCDD2),
    Color(0xFFC62828),

    // Amarelos / Laranjas
    Color(0xFFFFC107), Color(0xFFFFA726), Color(0xFFFF9800), Color(0xFFFF7043),
    Color(0xFFF57C00),
    Color(0xFFFFB300), Color(0xFFFFCA28), Color(0xFFFFEB3B), Color(0xFFFFE082),
    Color(0xFFFF6F00),

    // Roxos / Violetas
    Color(0xFF9C27B0), Color(0xFFBA68C8), Color(0xFF7B1FA2), Color(0xFF9575CD),
    Color(0xFFB39DDB),
    Color(0xFF8E24AA), Color(0xFFCE93D8), Color(0xFFE1BEE7), Color(0xFF4A148C),
    Color(0xFF6A1B9A),

    // Cianos / Turquesas
    Color(0xFF00BCD4), Color(0xFF4DD0E1), Color(0xFF0097A7), Color(0xFF26C6DA),
    Color(0xFF80DEEA),
    Color(0xFF00ACC1), Color(0xFFB2EBF2), Color(0xFFE0F7FA), Color(0xFF006064),
    Color(0xFF00838F),

    // Marrons / Terrosos
    Color(0xFF795548), Color(0xFFA1887F), Color(0xFF5D4037), Color(0xFF8D6E63),
    Color(0xFFD7CCC8),
    Color(0xFF3E2723), Color(0xFF6D4C41), Color(0xFFBCAAA4), Color(0xFF4E342E),
    Color(0xFFEDE7F6),

    // Cinzas / Neutros
    Color(0xFF607D8B), Color(0xFF90A4AE), Color(0xFF455A64), Color(0xFFB0BEC5),
    Color(0xFFCFD8DC),
    Color(0xFFECEFF1), Color(0xFF78909C), Color(0xFF37474F), Color(0xFF212121),
    Color(0xFFEEEEEE),

    // Cores vivas e contraste
    Color(0xFF00E676), Color(0xFF69F0AE), Color(0xFFFFD54F), Color(0xFFFFB74D),
    Color(0xFFFF8A65),
    Color(0xFF00B8D4), Color(0xFF00E5FF), Color(0xFF1DE9B6), Color(0xFFFFEA00),
    Color(0xFFFF3D00),

    // Escuros profundos
    Color(0xFF263238), Color(0xFF1A237E), Color(0xFF004D40), Color(0xFF3E2723),
    Color(0xFF212121),
    Color(0xFF0D47A1), Color(0xFF311B92), Color(0xFF1B1B1B), Color(0xFF102027),
    Color(0xFF2C2C2C),

    // Alternativas vibrantes
    Color(0xFFEEFF41), Color(0xFFFFD740), Color(0xFFB2FF59), Color(0xFF69F0AE),
    Color(0xFF40C4FF),
    Color(0xFFFF6E40), Color(0xFFFF4081), Color(0xFFE040FB), Color(0xFF7C4DFF),
    Color(0xFF536DFE),

    // Neon / Tech
    Color(0xFF64FFDA), Color(0xFF18FFFF), Color(0xFF00E5FF), Color(0xFF1DE9B6),
    Color(0xFF76FF03),
    Color(0xFFD500F9), Color(0xFFFF1744), Color(0xFFFF9100), Color(0xFF6200EA),
    Color(0xFF00BFA5),

    // Pastéis criativos
    Color(0xFFFFF8E1), Color(0xFFFFF3E0), Color(0xFFFFFDE7), Color(0xFFE8F5E9),
    Color(0xFFE3F2FD),
    Color(0xFFFBE9E7), Color(0xFFF9FBE7), Color(0xFFF3E5F5), Color(0xFFE1F5FE),
    Color(0xFFE0F2F1),

    // Outras misturas
    Color(0xFF4CAF50), Color(0xFF7CB342), Color(0xFFCDDC39), Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFFF44336), Color(0xFF9E9D24), Color(0xFF009688), Color(0xFF3F51B5),
    Color(0xFF673AB7),];

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
