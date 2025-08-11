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
    // Pasteis
    Color(0xFFd0e1f1), Color(0xFFc9d9fa), Color(0xFFd1e0e5), Color(0xFFd7ebd0),
    Color(0xFFfff2cf),
    Color(0xFFfbe6cb), Color(0xFFf5cbcc), Color(0xFFe5b9b0), Color(0xFFe8d3dc),
    Color(0xFFdad3e5),

    // Pasteis escuros
    Color(0xFFa2c5e3), Color(0xFFa4c2f4), Color(0xFFa5c2c6), Color(0xFFb1d6a0),
    Color(0xFFffe49b),
    Color(0xFFf7cd93), Color(0xFFde9e94), Color(0xFFe07d6a), Color(0xFFcfa9c0),
    Color(0xFFb4a7d5),

    // Normais
    Color(0xFF6ca9df), Color(0xFF6c9dec), Color(0xFF75a7a8), Color(0xFF91c481),
    Color(0xFFfadc64),
    Color(0xFFf9b36e), Color(0xFFdd6763), Color(0xFFcf3e2b), Color(0xFFc57ba0),
    Color(0xFF8f7cbe),

    // Normais escuras
    Color(0xFF3d85c6), Color(0xFF3c78d8), Color(0xFF45818e), Color(0xFF6aa84f),
    Color(0xFFf1c232),
    Color(0xFFe69138), Color(0xFFcc0000), Color(0xFF85200c), Color(0xFFa64d79),
    Color(0xFF351c75),

    // Marrons / Terrosos
    Color(0xFF0b5394), Color(0xFF1155cc), Color(0xFF134f5c), Color(0xFF38761d),
    Color(0xFFbf9000),
    Color(0xFFb45f06), Color(0xFF990000), Color(0xFF85200c), Color(0xFF741b47),
    Color(0xFF741b47),

    // Cinzas / Neutros
    Color(0xFF073763), Color(0xFF1c4587), Color(0xFF0c343d), Color(0xFF274e13),
    Color(0xFF7f6000), Color(0xFF783f04), Color(0xFF660000), Color(0xFF5b0f00),
    Color(0xFF4c1130), Color(0xFF20124d),
  ];

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
