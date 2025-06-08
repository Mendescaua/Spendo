import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class CategoriaComboBox extends ConsumerStatefulWidget {
  final Function(String nome, String tipo) onCategoriaSelecionada;

  const CategoriaComboBox({
    super.key,
    required this.onCategoriaSelecionada,
  });

  @override
  ConsumerState<CategoriaComboBox> createState() => _CategoriaComboBoxState();
}

class _CategoriaComboBoxState extends ConsumerState<CategoriaComboBox> {
  List<CategoryTransactionModel> categoriasBanco = [];
  Map<String, IconData> categoriasFixasComIcones = {
    'Investimento': Iconsax.chart,
    'Pix': Iconsax.wallet_2,
    'Outros': Iconsax.note,
  };
  Map<String, Color> coresCategoria = {
    'Investimento': const Color(0xFF3A86FF),
    'Pix': const Color(0xFF8338EC),
    'Outros': Colors.grey.shade600,
  };

  String? categoriaSelecionada;
  String? tipoSelecionado;

  final List<Map<String, dynamic>> iconesDisponiveis = [
    {'icone': Iconsax.activity, 'tipo': 'I00'},
    {'icone': Iconsax.add, 'tipo': 'I01'},
    {'icone': Iconsax.add_circle, 'tipo': 'I02'},
    {'icone': Iconsax.archive, 'tipo': 'I03'},
    {'icone': Iconsax.archive_add, 'tipo': 'I04'},
    {'icone': Iconsax.archive_minus, 'tipo': 'I05'},
    {'icone': Iconsax.award, 'tipo': 'I06'},
    {'icone': Iconsax.bank, 'tipo': 'I07'},
    {'icone': Iconsax.barcode, 'tipo': 'I08'},
    {'icone': Iconsax.book, 'tipo': 'I09'},
    {'icone': Iconsax.bookmark, 'tipo': 'I10'},
    {'icone': Iconsax.briefcase, 'tipo': 'I11'},
    {'icone': Iconsax.calendar, 'tipo': 'I12'},
    {'icone': Iconsax.camera, 'tipo': 'I13'},
    {'icone': Iconsax.chart, 'tipo': 'I14'},
    {'icone': Iconsax.chart_1, 'tipo': 'I15'},
    {'icone': Iconsax.chart_2, 'tipo': 'I16'},
    {'icone': Iconsax.chart_3, 'tipo': 'I17'},
    {'icone': Iconsax.chart_square, 'tipo': 'I18'},
    {'icone': Iconsax.check, 'tipo': 'I19'},
    {'icone': Iconsax.cloud, 'tipo': 'I20'},
    {'icone': Iconsax.code, 'tipo': 'I21'},
    {'icone': Iconsax.coin, 'tipo': 'I22'},
    {'icone': Iconsax.convert, 'tipo': 'I23'},
    {'icone': Iconsax.crown, 'tipo': 'I24'},
    {'icone': Iconsax.cup, 'tipo': 'I25'},
    {'icone': Iconsax.danger, 'tipo': 'I26'},
    {'icone': Iconsax.data, 'tipo': 'I27'},
    {'icone': Iconsax.document, 'tipo': 'I30'},
    {'icone': Iconsax.document_text, 'tipo': 'I31'},
    {'icone': Iconsax.dollar_circle, 'tipo': 'I32'},
    {'icone': Iconsax.edit, 'tipo': 'I33'},
    {'icone': Iconsax.emoji_happy, 'tipo': 'I34'},
    {'icone': Iconsax.export, 'tipo': 'I35'},
    {'icone': Iconsax.eye, 'tipo': 'I36'},
    {'icone': Iconsax.filter, 'tipo': 'I37'},
    {'icone': Iconsax.flag, 'tipo': 'I38'},
    {'icone': Iconsax.folder, 'tipo': 'I39'},
    {'icone': Iconsax.game, 'tipo': 'I40'},
    {'icone': Iconsax.gift, 'tipo': 'I41'},
    {'icone': Iconsax.global, 'tipo': 'I42'},
    {'icone': Iconsax.graph, 'tipo': 'I43'},
    {'icone': Iconsax.heart, 'tipo': 'I45'},
    {'icone': Iconsax.home, 'tipo': 'I46'},
    {'icone': Iconsax.image, 'tipo': 'I47'},
    {'icone': Iconsax.info_circle, 'tipo': 'I48'},
    {'icone': Iconsax.lamp, 'tipo': 'I49'},
    {'icone': Iconsax.like, 'tipo': 'I51'},
    {'icone': Iconsax.link, 'tipo': 'I52'},
    {'icone': Iconsax.location, 'tipo': 'I53'},
    {'icone': Iconsax.lock, 'tipo': 'I54'},
    {'icone': Iconsax.login, 'tipo': 'I55'},
    {'icone': Iconsax.logout, 'tipo': 'I56'},
    {'icone': Iconsax.map, 'tipo': 'I57'},
    {'icone': Iconsax.menu, 'tipo': 'I58'},
    {'icone': Iconsax.message, 'tipo': 'I59'},
    {'icone': Iconsax.minus, 'tipo': 'I61'},
    {'icone': Iconsax.money, 'tipo': 'I62'},
    {'icone': Iconsax.moon, 'tipo': 'I63'},
    {'icone': Iconsax.music, 'tipo': 'I64'},
    {'icone': Iconsax.notification, 'tipo': 'I65'},
    {'icone': Iconsax.paperclip, 'tipo': 'I66'},
    {'icone': Iconsax.play, 'tipo': 'I71'},
    {'icone': Iconsax.profile, 'tipo': 'I73'},
    {'icone': Iconsax.receipt, 'tipo': 'I75'},
    {'icone': Iconsax.refresh, 'tipo': 'I76'},
    {'icone': Iconsax.security, 'tipo': 'I78'},
    {'icone': Iconsax.send, 'tipo': 'I79'},
    {'icone': Iconsax.setting, 'tipo': 'I80'},
    {'icone': Iconsax.shield, 'tipo': 'I81'},
    {'icone': Iconsax.shop, 'tipo': 'I82'},
    {'icone': Iconsax.star, 'tipo': 'I83'},
    {'icone': Iconsax.sun, 'tipo': 'I84'},
    {'icone': Iconsax.tag, 'tipo': 'I85'},
    {'icone': Iconsax.timer, 'tipo': 'I86'},
    {'icone': Iconsax.trash, 'tipo': 'I87'},
    {'icone': Iconsax.unlock, 'tipo': 'I88'},
  ];

  final Map<String, IconData> iconesPorTipo = {
    'I00': Iconsax.activity,
    'I01': Iconsax.add,
    'I02': Iconsax.add_circle,
    'I03': Iconsax.archive,
    'I04': Iconsax.archive_add,
    'I05': Iconsax.archive_minus,
    'I06': Iconsax.award,
    'I07': Iconsax.bank,
    'I08': Iconsax.barcode,
    'I09': Iconsax.book,
    'I10': Iconsax.bookmark,
    'I11': Iconsax.briefcase,
    'I12': Iconsax.calendar,
    'I13': Iconsax.camera,
    'I14': Iconsax.chart,
    'I15': Iconsax.chart_1,
    'I16': Iconsax.chart_2,
    'I17': Iconsax.chart_3,
    'I18': Iconsax.chart_square,
    'I19': Iconsax.check,
    'I20': Iconsax.cloud,
    'I21': Iconsax.code,
    'I22': Iconsax.coin,
    'I23': Iconsax.convert,
    'I24': Iconsax.crown,
    'I25': Iconsax.cup,
    'I26': Iconsax.danger,
    'I27': Iconsax.data,
    'I30': Iconsax.document,
    'I31': Iconsax.document_text,
    'I32': Iconsax.dollar_circle,
    'I33': Iconsax.edit,
    'I34': Iconsax.emoji_happy,
    'I35': Iconsax.export,
    'I36': Iconsax.eye,
    'I37': Iconsax.filter,
    'I38': Iconsax.flag,
    'I39': Iconsax.folder,
    'I40': Iconsax.game,
    'I41': Iconsax.gift,
    'I42': Iconsax.global,
    'I43': Iconsax.graph,
    'I45': Iconsax.heart,
    'I46': Iconsax.home,
    'I47': Iconsax.image,
    'I48': Iconsax.info_circle,
    'I49': Iconsax.lamp,
    'I51': Iconsax.like,
    'I52': Iconsax.link,
    'I53': Iconsax.location,
    'I54': Iconsax.lock,
    'I55': Iconsax.login,
    'I56': Iconsax.logout,
    'I57': Iconsax.map,
    'I58': Iconsax.menu,
    'I59': Iconsax.message,
    'I61': Iconsax.minus,
    'I62': Iconsax.money,
    'I63': Iconsax.moon,
    'I64': Iconsax.music,
    'I65': Iconsax.notification,
    'I66': Iconsax.paperclip,
    'I71': Iconsax.play,
    'I73': Iconsax.profile,
    'I75': Iconsax.receipt,
    'I76': Iconsax.refresh,
    'I78': Iconsax.security,
    'I79': Iconsax.send,
    'I80': Iconsax.setting,
    'I81': Iconsax.shield,
    'I82': Iconsax.shop,
    'I83': Iconsax.star,
    'I84': Iconsax.sun,
    'I85': Iconsax.tag,
    'I86': Iconsax.timer,
    'I87': Iconsax.trash,
    'I88': Iconsax.unlock,
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
    Color corSelecionadaDialog = Colors.blue;

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
                      color: Colors.grey[300],
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
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: iconesDisponiveis
                                        .sublist(3)
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
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: const Icon(Icons.more_horiz),
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
                                  content: Wrap(
                                    spacing: 8,
                                    runSpacing:
                                        8, // espaçamento vertical entre as linhas do wrap
                                    children: [
                                      Colors.red,
                                      Colors.orange,
                                      Colors.green,
                                      Colors.blue,
                                      Colors.purple,
                                      Colors.teal,
                                      Colors.brown,
                                      Colors.pink,
                                      Colors.indigo,
                                      Colors.lime,
                                      Colors.cyan,
                                      Colors.amber,
                                      Colors.deepOrange,
                                      Colors.deepPurple,
                                      Colors.lightBlue,
                                      Colors.lightGreen,
                                      Colors.yellow,
                                      Colors.grey,
                                    ].map((cor) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0), // espaço inferior
                                        child: GestureDetector(
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
                                                  color: Colors.black12,
                                                  width: 1),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
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
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: corSelecionadaDialog,
                                borderRadius: BorderRadius.circular(12),
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
                                categoriasFixasComIcones[nomeNovaCategoria] =
                                    iconeSelecionado!;
                                coresCategoria[nomeNovaCategoria] =
                                    corSelecionadaDialog;
                                categoriaSelecionada = nomeNovaCategoria;
                                tipoSelecionado = tipoSelecionadoDialog;
                              });

                              widget.onCategoriaSelecionada(
                                  nomeNovaCategoria, tipoSelecionadoDialog!);

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
        return coresCategoria[nome] ?? AppTheme.primaryColor;
      }
    }
    return coresCategoria[nome] ?? AppTheme.primaryColor;
  }

  void _abrirModalCategorias(BuildContext context) {
    final Map<String, IconData> todasCategoriasComIcones = {
      ...categoriasFixasComIcones,
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
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
                          widget.onCategoriaSelecionada(nome, tipoDaCategoria);
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
                          ? (categoriasFixasComIcones[categoriaSelecionada!] ??
                              iconesPorTipo[tipoSelecionado ?? ''] ??
                              Iconsax.note)
                          : Iconsax.category,
                      color: Colors.white,
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
