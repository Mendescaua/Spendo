import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class CategoriaComboBox extends ConsumerStatefulWidget {
  final Function(String nome, String tipo, Color cor) onCategoriaSelecionada;

  const CategoriaComboBox({
    super.key,
    required this.onCategoriaSelecionada,
  });

  @override
  ConsumerState<CategoriaComboBox> createState() => _CategoriaComboBoxState();
}

class _CategoriaComboBoxState extends ConsumerState<CategoriaComboBox> {
  List<CategoryTransactionModel> categoriasBanco = [];

  String? categoriaSelecionada;
  String? tipoSelecionado;

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
  final Map<String, IconData> iconesPorTipo = {
    'I00': Iconsax.card,
    'I01': Iconsax.ticket_star,
    'I02': Iconsax.video,
    'I03': Iconsax.music,
    'I04': Iconsax.video_play,
    'I05': Iconsax.bank,
    'I06': Iconsax.briefcase,
    'I07': Iconsax.calendar,
    'I08': Iconsax.chart_1,
    'I09': Iconsax.chart_2,
    'I10': Iconsax.emoji_happy,
    'I11': Iconsax.game,
    'I12': Iconsax.gift,
    'I13': Iconsax.global,
    'I14': Iconsax.heart,
    'I15': Iconsax.home,
    'I16': Iconsax.security,
    'I17': Iconsax.shop,
    'I18': Iconsax.star,
    'I19': Iconsax.tag,
    'I20': Iconsax.trash,
    'I21': Iconsax.airplane,
    'I22': Iconsax.gas_station,
    'I23': Iconsax.shopping_cart,
    'I24': Iconsax.book,
    'I25': Iconsax.teacher,
    'I26': Iconsax.rulerpen,
    'I27': Iconsax.cake,
    'I28': Iconsax.coffee,
    'I29': Iconsax.pet,
    'I30': Iconsax.mobile,
    'I31': Iconsax.gameboy,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carregarCategoriasBanco();
    });
  }

  Future<void> carregarCategoriasBanco() async {
    final controller = ref.read(transactionControllerProvider.notifier);
    final res = await controller.getCategoryTransaction();
    if (res == null) {
      setState(() {
        categoriasBanco = controller.categories;
      });
    } else {
      print('Erro ao carregar categorias do banco: $res');
    }
  }

  void onSave(
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
      await carregarCategoriasBanco();
    }
  }

// Dentro da classe _CategoriaComboBoxState:

  Future<void> _abrirModalCriarCategoria(BuildContext context) async {
    String nomeNovaCategoria = '';
    IconData? iconeSelecionado;
    String? tipoSelecionadoDialog;
    Color corSelecionadaDialog = AppTheme.primaryColor;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Criar nova categoria',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (value) {
                          nomeNovaCategoria = value.trim();
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.attach_square),
                          hintText: 'Digite o nome da categoria',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Selecione um ícone',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      // Mostrar apenas 3 ícones iniciais
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        children: [
                          for (int i = 0; i < 5; i++)
                            _iconeItemDialog(
                                iconesDisponiveis[i], iconeSelecionado,
                                (icon, tipo) {
                              setStateDialog(() {
                                iconeSelecionado = icon;
                                tipoSelecionadoDialog = tipo;
                              });
                            }),

                          // Botão "Outros"
                          GestureDetector(
                            onTap: () async {
                              final resultado = await showModalBottomSheet<
                                  Map<String, dynamic>>(
                                context: context,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                builder: (context) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Selecione um ícone',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: iconesDisponiveis
                                            .map((item) => _iconeItemDialog(
                                                  item,
                                                  iconeSelecionado,
                                                  (icon, tipo) {
                                                    Navigator.pop(context, {
                                                      'icone': icon,
                                                      'tipo': tipo,
                                                    });
                                                  },
                                                ))
                                            .toList(),
                                      ),
                                      SizedBox(height: 30),
                                    ],
                                  ),
                                ),
                              );

                              if (resultado != null) {
                                setStateDialog(() {
                                  iconeSelecionado = resultado['icone'];
                                  tipoSelecionadoDialog = resultado['tipo'];
                                });
                              }
                            },
                            child: Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Iconsax.more,
                                color: AppTheme.whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
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
                                      children: [
                                        ...[
                                          // 🔵 Azuis
                                          Color(0xFF2196F3),
                                          Color(0xFF64B5F6),
                                          Color(0xFF0D47A1),

                                          // 🟣 Roxos
                                          Color(0xFF9C27B0),
                                          Color(0xFFBA68C8),
                                          Color(0xFF4A148C),

                                          // 🟢 Verdes
                                          Color(0xFF4CAF50),
                                          Color(0xFF81C784),
                                          Color(0xFF1B5E20),

                                          // 🟠 Laranjas
                                          Color(0xFFFF9800),
                                          Color(0xFFFFB74D),
                                          Color(0xFFE65100),

                                          // 🔴 Vermelhos
                                          Color(0xFFF44336),
                                          Color(0xFFE57373),
                                          Color(0xFFB71C1C),

                                          // 🎨 Aleatórias
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
                                        ].map((cor) {
                                          return GestureDetector(
                                            onTap: () =>
                                                Navigator.pop(context, cor),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: cor,
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                    color: Colors.black12),
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              if (corEscolhida != null) {
                                setStateDialog(() {
                                  corSelecionadaDialog = corEscolhida;
                                });
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: corSelecionadaDialog,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              if (nomeNovaCategoria.isEmpty ||
                                  tipoSelecionadoDialog == null ||
                                  iconeSelecionado == null) return;

                              final corHex =
                                  '#${corSelecionadaDialog.value.toRadixString(16).padLeft(8, '0')}';
                              onSave(nomeNovaCategoria, tipoSelecionadoDialog!,
                                  corHex);

                              setState(() {
                                categoriaSelecionada = nomeNovaCategoria;
                                tipoSelecionado = tipoSelecionadoDialog;
                              });

                              widget.onCategoriaSelecionada(nomeNovaCategoria,
                                  tipoSelecionadoDialog!, corSelecionadaDialog);

                              Navigator.pop(context);
                            },
                            child: const Text('Salvar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

// Componente auxiliar para renderizar ícones com seleção
  Widget _iconeItemDialog(Map<String, dynamic> item, IconData? iconeSelecionado,
      void Function(IconData, String) onSelect) {
    final icone = item['icone'] as IconData;
    final tipo = item['tipo'] as String;
    final isSelected = iconeSelecionado == icone;

    return GestureDetector(
      onTap: () => onSelect(icone, tipo),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          icone,
          color: isSelected ? AppTheme.primaryColor : Colors.grey[600],
        ),
      ),
    );
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // adiciona alpha se não existir
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  Color obterCorCategoria(String nome) {
    final cat = categoriasBanco.firstWhere(
      (c) => c.name == nome,
      orElse: () => CategoryTransactionModel(name: nome, type: '', color: ''),
    );
    if (cat.color.isNotEmpty) {
      try {
        return hexToColor(cat.color);
      } catch (_) {
        return AppTheme.primaryColor;
      }
    }
    return AppTheme.primaryColor;
  }

  void _abrirModalCategorias(BuildContext context) {
    final Map<String, IconData> todasCategoriasComIcones = {
      for (var cat in categoriasBanco)
        cat.name: iconesPorTipo[cat.type] ?? Iconsax.note,
    };

    final Map<String, String> tiposCategoriasBanco = {
      for (var cat in categoriasBanco) cat.name: cat.type,
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecionar categoria',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: todasCategoriasComIcones.entries.map((entry) {
                  final nome = entry.key;
                  final icone = entry.value;
                  final cor = obterCorCategoria(nome);
                  final tipoDaCategoria = tiposCategoriasBanco[nome] ??
                      (iconesDisponiveis.firstWhere(
                            (item) => item['icone'] == icone,
                            orElse: () => {'tipo': ''},
                          )['tipo'] as String? ??
                          '');

                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() {
                            categoriaSelecionada = nome;
                            tipoSelecionado = tipoDaCategoria;
                          });
                          widget.onCategoriaSelecionada(
                              nome, tipoDaCategoria, cor);
                          Navigator.pop(context);
                        },
                        leading: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: cor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icone, color: Colors.white),
                        ),
                        title: Text(nome),
                        trailing: (categoriaSelecionada == nome)
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                      ),
                      Divider(
                        color: Colors.grey.shade300,
                        height: 1,
                      ),
                    ],
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 50,
                child: StyleButton(
                    text: 'Criar nova categoria',
                    onClick: () async {
                      Navigator.pop(context); // fecha o modal atual
                      await _abrirModalCriarCategoria(
                          context); // abre o modal de criação
                      // Opcional: reabrir o modal principal depois de fechar o de criação
                      _abrirModalCategorias(context);
                    }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _abrirModalCategorias(context),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.shade600,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.only(left: 12, right: 12),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: categoriaSelecionada != null
                          ? obterCorCategoria(categoriaSelecionada!)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      categoriaSelecionada != null
                          ? (iconesPorTipo[tipoSelecionado ?? ''] ??
                              Iconsax.note)
                          : Iconsax.category,
                      color: AppTheme.whiteColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      categoriaSelecionada ?? 'Selecione uma categoria',
                      style: TextStyle(
                        fontSize: 16,
                        color: categoriaSelecionada != null
                            ? Colors.black
                            : Colors.grey.shade800,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
