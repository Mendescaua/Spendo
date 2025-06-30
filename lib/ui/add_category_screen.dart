import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
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
    {'icone': Iconsax.card, 'tipo': 'I00'},
    {'icone': Iconsax.ticket_star, 'tipo': 'I01'},
    {'icone': Iconsax.video, 'tipo': 'I02'},
    {'icone': Iconsax.music, 'tipo': 'I03'},
    {'icone': Iconsax.video_play, 'tipo': 'I04'},
    {'icone': Iconsax.bank, 'tipo': 'I05'},
    {'icone': Iconsax.briefcase, 'tipo': 'I06'},
    {'icone': Iconsax.calendar, 'tipo': 'I07'},
    {'icone': Iconsax.chart_1, 'tipo': 'I08'},
    {'icone': Iconsax.chart_2, 'tipo': 'I09'},
    {'icone': Iconsax.emoji_happy, 'tipo': 'I10'},
    {'icone': Iconsax.game, 'tipo': 'I11'},
    {'icone': Iconsax.gift, 'tipo': 'I12'},
    {'icone': Iconsax.global, 'tipo': 'I13'},
    {'icone': Iconsax.heart, 'tipo': 'I14'},
    {'icone': Iconsax.home, 'tipo': 'I15'},
    {'icone': Iconsax.security, 'tipo': 'I16'},
    {'icone': Iconsax.shop, 'tipo': 'I17'},
    {'icone': Iconsax.star, 'tipo': 'I18'},
    {'icone': Iconsax.tag, 'tipo': 'I19'},
    {'icone': Iconsax.trash, 'tipo': 'I20'},
    {'icone': Iconsax.airplane, 'tipo': 'I21'},
    {'icone': Iconsax.gas_station, 'tipo': 'I22'},
    {'icone': Iconsax.shopping_cart, 'tipo': 'I23'},
    {'icone': Iconsax.book, 'tipo': 'I24'},
    {'icone': Iconsax.teacher, 'tipo': 'I25'},
    {'icone': Iconsax.rulerpen, 'tipo': 'I26'},
    {'icone': Iconsax.cake, 'tipo': 'I27'},
    {'icone': Iconsax.coffee, 'tipo': 'I28'},
    {'icone': Iconsax.pet, 'tipo': 'I29'},
    {'icone': Iconsax.mobile, 'tipo': 'I30'},
    {'icone': Iconsax.gameboy, 'tipo': 'I31'},
  ];

  final List<Color> _coresDisponiveis = [
    Color(0xFF2196F3),
    Color(0xFF64B5F6),
    Color(0xFF0D47A1),
    Color(0xFF9C27B0),
    Color(0xFFBA68C8),
    Color(0xFF4A148C),
    Color(0xFF4CAF50),
    Color(0xFF81C784),
    Color(0xFF1B5E20),
    Color(0xFFFF9800),
    Color(0xFFFFB74D),
    Color(0xFFE65100),
    Color(0xFFF44336),
    Color(0xFFE57373),
    Color(0xFFB71C1C),
    Color(0xFF00BCD4),
    Color(0xFF607D8B),
    Color(0xFF795548),
    Color(0xFF00E5FF),
    Color(0xFF8BC34A),
    Color(0xFFFF4081),
    Color(0xFFFFC107),
    Color(0xFF3F51B5),
    Color(0xFFCDDC39),
    Color(0xFFD4E157),
    Color(0xFFAA00FF),
    Color(0xFF263238),
    Color(0xFFFF1744),
    Color(0xFF1DE9B6),
    Color(0xFF6200EA),
    Color(0xFF009688),
    Color(0xFF33691E),
    Color(0xFFBF360C),
    Color(0xFF3E2723),
    Color(0xFF000000),
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
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.15)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Icon(
          icone,
          size: 30,
          color: isSelected ? AppTheme.primaryColor : Colors.grey[700],
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black : Colors.white,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cor.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
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
        elevation: 0,
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
                    const Text('Ícone',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 70,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          ...iconesDisponiveis.map(_iconeCarouselItem),
                          GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                              ),
                              builder: (_) => Padding(
                                padding: const EdgeInsets.all(16),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: iconesDisponiveis
                                      .map((item) => _iconeCarouselItem(item))
                                      .toList(),
                                ),
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Iconsax.more,
                                  color: Colors.white, size: 30),
                            ),
                          )
                        ],
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
                    const SizedBox(height: 36),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
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
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Salvar'),
                        ),
                      ],
                    ),
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
