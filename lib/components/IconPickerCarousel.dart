import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class IconPickerCarousel extends StatefulWidget {
  final String? selectedTipo;
  final Function(IconData icon, String tipo) onIconSelected;
  final Color selectedColor;

  IconPickerCarousel({
    required this.selectedTipo,
    required this.onIconSelected,
    required this.selectedColor,
  });

  @override
  State<IconPickerCarousel> createState() => _IconPickerCarouselState();
}

class _IconPickerCarouselState extends State<IconPickerCarousel> {
  final ScrollController _scrollController = ScrollController();

 final List<Map<String, dynamic>> iconesDisponiveis = [
    {'icone': PhosphorIcons.forkKnife(PhosphorIconsStyle.regular), 'tipo': 'I01'},
    {'icone': PhosphorIcons.tShirt(PhosphorIconsStyle.regular), 'tipo': 'I02'},
    {'icone': PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),'tipo': 'I03'},
    {'icone': PhosphorIcons.coffee(PhosphorIconsStyle.regular), 'tipo': 'I04'},
    {'icone': PhosphorIcons.cake(PhosphorIconsStyle.regular), 'tipo': 'I05'},
    {'icone': PhosphorIcons.gasPump(PhosphorIconsStyle.regular), 'tipo': 'I06'},
    {'icone': PhosphorIcons.wallet(PhosphorIconsStyle.regular), 'tipo': 'I07'},
    {'icone': PhosphorIcons.bank(PhosphorIconsStyle.regular), 'tipo': 'I08'},
    {'icone': PhosphorIcons.gift(PhosphorIconsStyle.regular), 'tipo': 'I09'},
    {'icone': PhosphorIcons.house(PhosphorIconsStyle.regular), 'tipo': 'I10'},
    {'icone': PhosphorIcons.basket(PhosphorIconsStyle.regular), 'tipo': 'I11'},
    {
      'icone': PhosphorIcons.bookOpen(PhosphorIconsStyle.regular),
      'tipo': 'I12'
    },
    {
      'icone': PhosphorIcons.chalkboardTeacher(PhosphorIconsStyle.regular),
      'tipo': 'I13'
    },
    {
      'icone': PhosphorIcons.pawPrint(PhosphorIconsStyle.regular),
      'tipo': 'I14'
    },
    {
      'icone': PhosphorIcons.airplaneTilt(PhosphorIconsStyle.regular),
      'tipo': 'I15'
    },
    {
      'icone': PhosphorIcons.briefcase(PhosphorIconsStyle.regular),
      'tipo': 'I16'
    },
    {
      'icone': PhosphorIcons.chartBar(PhosphorIconsStyle.regular),
      'tipo': 'I17'
    },
    {'icone': PhosphorIcons.heart(PhosphorIconsStyle.regular), 'tipo': 'I18'},
    {
      'icone': PhosphorIcons.shieldCheck(PhosphorIconsStyle.regular),
      'tipo': 'I19'
    },
    {
      'icone': PhosphorIcons.hamburger(PhosphorIconsStyle.regular),
      'tipo': 'I20'
    },
    {'icone': PhosphorIcons.pizza(PhosphorIconsStyle.regular), 'tipo': 'I21'},
    {
      'icone': PhosphorIcons.musicNote(PhosphorIconsStyle.regular),
      'tipo': 'I22'
    },
    {
      'icone': PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
      'tipo': 'I23'
    },
    {'icone': PhosphorIcons.ticket(PhosphorIconsStyle.regular), 'tipo': 'I24'},
    {'icone': PhosphorIcons.globe(PhosphorIconsStyle.regular), 'tipo': 'I25'},
    {
      'icone': PhosphorIcons.calendarBlank(PhosphorIconsStyle.regular),
      'tipo': 'I26'
    },
    {'icone': PhosphorIcons.penNib(PhosphorIconsStyle.regular), 'tipo': 'I27'},
    {
      'icone': PhosphorIcons.deviceMobile(PhosphorIconsStyle.regular),
      'tipo': 'I28'
    },
    {
      'icone': PhosphorIcons.firstAidKit(PhosphorIconsStyle.regular),
      'tipo': 'I29'
    },
    {
      'icone': PhosphorIcons.plugCharging(PhosphorIconsStyle.regular),
      'tipo': 'I30'
    },
    {'icone': PhosphorIcons.trophy(PhosphorIconsStyle.regular), 'tipo': 'I31'},
    {
      'icone': PhosphorIcons.treePalm(PhosphorIconsStyle.regular),
      'tipo': 'I32'
    },
    {'icone': PhosphorIcons.camera(PhosphorIconsStyle.regular), 'tipo': 'I33'},
    {
      'icone': PhosphorIcons.bugBeetle(PhosphorIconsStyle.regular),
      'tipo': 'I34'
    },
    {'icone': PhosphorIcons.dress(PhosphorIconsStyle.regular), 'tipo': 'I35'},
    {
      'icone': PhosphorIcons.armchair(PhosphorIconsStyle.regular),
      'tipo': 'I36'
    },
    {'icone': PhosphorIcons.trash(PhosphorIconsStyle.regular), 'tipo': 'I37'},
    {'icone': PhosphorIcons.tag(PhosphorIconsStyle.regular), 'tipo': 'I38'},
    {
      'icone': PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
      'tipo': 'I39'
    },
    {
      'icone': PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
      'tipo': 'I40'
    },
    {
      'icone': PhosphorIcons.shoppingBag(PhosphorIconsStyle.regular),
      'tipo': 'I41'
    },
    {
      'icone': PhosphorIcons.phoneCall(PhosphorIconsStyle.regular),
      'tipo': 'I42'
    },
    {
      'icone': PhosphorIcons.notePencil(PhosphorIconsStyle.regular),
      'tipo': 'I43'
    },
    {'icone': PhosphorIcons.coins(PhosphorIconsStyle.regular), 'tipo': 'I44'},
    {
      'icone': PhosphorIcons.paintBrush(PhosphorIconsStyle.regular),
      'tipo': 'I45'
    },
    {'icone': PhosphorIcons.bus(PhosphorIconsStyle.regular), 'tipo': 'I46'},
    {
      'icone': PhosphorIcons.gameController(PhosphorIconsStyle.regular),
      'tipo': 'I47'
    },
    {
      'icone': PhosphorIcons.currencyCircleDollar(PhosphorIconsStyle.regular),
      'tipo': 'I48'
    },
    {'icone': PhosphorIcons.package(PhosphorIconsStyle.regular), 'tipo': 'I49'},
    {'icone': PhosphorIcons.jeep(PhosphorIconsStyle.regular), 'tipo': 'I50'},
    {'icone': PhosphorIcons.laptop(PhosphorIconsStyle.regular), 'tipo': 'I51'},
    {'icone': PhosphorIcons.lego(PhosphorIconsStyle.regular), 'tipo': 'I52'},
    {
      'icone': PhosphorIcons.motorcycle(PhosphorIconsStyle.regular),
      'tipo': 'I53'
    },
    {'icone': PhosphorIcons.popcorn(PhosphorIconsStyle.regular), 'tipo': 'I54'},
    {
      'icone': PhosphorIcons.spotifyLogo(PhosphorIconsStyle.regular),
      'tipo': 'I55'
    },
    {'icone': PhosphorIcons.taxi(PhosphorIconsStyle.regular), 'tipo': 'I56'},
  ];

@override
void initState() {
  super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) async {
  await Future.delayed(const Duration(milliseconds: 100));

  final selectedIndex = iconesDisponiveis.indexWhere(
    (icon) => icon['tipo'] == widget.selectedTipo,
  );

  if (selectedIndex == -1) return;

  const double itemWidth = 60;
  const double separatorWidth = 12;
  final double itemExtent = itemWidth + separatorWidth;
  final double listViewWidth = MediaQuery.of(context).size.width - 24;
  final double maxScroll = _scrollController.position.maxScrollExtent;

  double targetOffset = (selectedIndex * itemExtent) - (listViewWidth / 2) + (itemExtent / 2);

  if (targetOffset < 0) targetOffset = 0;
  if (targetOffset > maxScroll) targetOffset = maxScroll;

  // Imprime os valores para debug:
  print('selectedIndex: $selectedIndex');
  print('maxScrollExtent: $maxScroll');
  print('calculated targetOffset: $targetOffset');

  _scrollController.animateTo(
    targetOffset,
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeOut,
  );
});


}



  @override
  Widget build(BuildContext context) {
    final selectedIcon = iconesDisponiveis
        .firstWhere(
          (element) => element['tipo'] == widget.selectedTipo,
          orElse: () => {},
        )['icone'] as IconData?;

    return SizedBox(
      height: 50,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: iconesDisponiveis.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final iconData = iconesDisponiveis[index]['icone'] as IconData;
          final tipo = iconesDisponiveis[index]['tipo'] as String;
          final isSelected = iconData == selectedIcon;

          return GestureDetector(
            onTap: () => widget.onIconSelected(iconData, tipo),
            child: AnimatedContainer(
              width: 50,
              height: 50,
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected ? widget.selectedColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Icon(
                iconData,
                size: 22,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          );
        },
      ),
    );
  }
}
