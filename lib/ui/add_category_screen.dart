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
    Color(0xFF673AB7),
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
    }
  }

  Widget _iconeCarouselItem(Map<String, dynamic> item) {
    final icone = item['icone'] as IconData;
    final tipo = item['tipo'] as String;
    final isSelected = iconeSelecionado == icone;

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
          color: isSelected ? Colors.white : Colors.grey[700],
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
        margin: const EdgeInsets.only(right: 12),
        width: 40,
        height: 36,
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
              decoration: const BoxDecoration(
                color: AppTheme.backgroundColor,
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
                        prefixIcon: const Icon(Iconsax.edit),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Cor',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            _coresDisponiveis.map(_corCarouselItem).toList(),
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

                            Navigator.pop(context, true);
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
