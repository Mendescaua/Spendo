import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class CriarCategoriaScreen extends ConsumerStatefulWidget {
  const CriarCategoriaScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CriarCategoriaScreen> createState() =>
      _CriarCategoriaScreenState();
}

class _CriarCategoriaScreenState extends ConsumerState<CriarCategoriaScreen> {
  String nomeNovaCategoria = '';
  IconData? iconeSelecionado;
  String? tipoSelecionadoDialog;
  Color corSelecionadaDialog = AppTheme.primaryColor;

  final List<Map<String, dynamic>> iconesDisponiveis = [
    {
      'icone': PhosphorIcons.forkKnife(PhosphorIconsStyle.regular),
      'tipo': 'I01'
    },
    {'icone': PhosphorIcons.tShirt(PhosphorIconsStyle.regular), 'tipo': 'I02'},
    {
      'icone': PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),
      'tipo': 'I03'
    },
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

  final List<Color> _coresDisponiveis = [
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

  Future<void> onSave(
      String nomeNovaCategoria, String tipoNovaCategoria, String corHex) async {
    final controller = ref.read(transactionControllerProvider.notifier);
    final resposta = await controller.addCategoryTransaction(
      transaction: CategoryTransactionModel(
        name: nomeNovaCategoria,
        type: tipoNovaCategoria,
        color: corHex,
      ),
    );
    if (resposta != null) {
      FloatingMessage(context, resposta, 'error', 2);
    } else {
      FloatingMessage(
          context, 'Categoria adicionada com sucesso', 'success', 2);
      Navigator.pop(context, true);
    }
  }

  Widget _iconeCarouselItem(Map<String, dynamic> item) {
    final icone = item['icone'] as IconData;
    final tipo = item['tipo'] as String;
    final isSelected = iconeSelecionado == icone;

    final iconColor = isSelected
        ? AppTheme.dynamicIconColor(corSelecionadaDialog)
        : Colors.grey[700];

    return GestureDetector(
      onTap: () {
        setState(() {
          iconeSelecionado = icone;
          tipoSelecionadoDialog = tipo;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? corSelecionadaDialog : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Icon(
          icone,
          size: 30,
          color: iconColor,
        ),
      ),
    );
  }
Widget _corCarouselItem(Color cor) {
  final isSelected = corSelecionadaDialog == cor;

  return GestureDetector(
    onTap: () {
      setState(() {
        corSelecionadaDialog = cor;
      });
    },
    child: Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.black : Colors.white,
          width: 2,
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: const Text('Criar nova categoria'),
        backgroundColor: AppTheme.primaryColor,
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) => nomeNovaCategoria = value.trim(),
                      decoration: InputDecoration(
                        hintText: 'Nome da categoria',
                        hintStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                        filled: true,
                        fillColor: AppTheme.dynamicCardColor(context),
                        prefixIcon: Icon(
                          Iconsax.edit,
                          size: 24,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 18),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Cor',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            Row(
                              children: _coresDisponiveis
                                  .sublist(
                                      0, (_coresDisponiveis.length / 2).ceil())
                                  .map(_corCarouselItem)
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: _coresDisponiveis
                                  .sublist(
                                      (_coresDisponiveis.length / 2).ceil())
                                  .map(_corCarouselItem)
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Ícone',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: GridView.count(
                        crossAxisCount: 3,
                        scrollDirection: Axis.horizontal,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                        children:
                            iconesDisponiveis.map(_iconeCarouselItem).toList(),
                      ),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      width: double.infinity,
                      child: StyleButton(
                          text: 'Salvar',
                          onClick: () async {
                            if (nomeNovaCategoria.isEmpty ||
                                tipoSelecionadoDialog == null ||
                                iconeSelecionado == null) {
                              FloatingMessage(
                                  context,
                                  'Preencha todos os campos para salvar',
                                  'error',
                                  2);
                              return;
                            }

                            final corHex =
                                '#${corSelecionadaDialog.value.toRadixString(16).padLeft(8, '0')}';

                            await onSave(nomeNovaCategoria,
                                tipoSelecionadoDialog!, corHex);
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
