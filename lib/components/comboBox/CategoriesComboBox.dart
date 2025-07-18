import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/ui/category/add_category_screen.dart';
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

  final Map<String, IconData> iconesPorTipo = {
    'I01': PhosphorIcons.forkKnife(PhosphorIconsStyle.regular),
    'I02': PhosphorIcons.tShirt(PhosphorIconsStyle.regular),
    'I03': PhosphorIcons.shoppingCart(PhosphorIconsStyle.regular),
    'I04': PhosphorIcons.coffee(PhosphorIconsStyle.regular),
    'I05': PhosphorIcons.cake(PhosphorIconsStyle.regular),
    'I06': PhosphorIcons.gasPump(PhosphorIconsStyle.regular),
    'I07': PhosphorIcons.wallet(PhosphorIconsStyle.regular),
    'I08': PhosphorIcons.bank(PhosphorIconsStyle.regular),
    'I09': PhosphorIcons.gift(PhosphorIconsStyle.regular),
    'I10': PhosphorIcons.house(PhosphorIconsStyle.regular),
    'I11': PhosphorIcons.basket(PhosphorIconsStyle.regular),
    'I12': PhosphorIcons.bookOpen(PhosphorIconsStyle.regular),
    'I13': PhosphorIcons.chalkboardTeacher(PhosphorIconsStyle.regular),
    'I14': PhosphorIcons.pawPrint(PhosphorIconsStyle.regular),
    'I15': PhosphorIcons.airplaneTilt(PhosphorIconsStyle.regular),
    'I16': PhosphorIcons.briefcase(PhosphorIconsStyle.regular),
    'I17': PhosphorIcons.chartBar(PhosphorIconsStyle.regular),
    'I18': PhosphorIcons.heart(PhosphorIconsStyle.regular),
    'I19': PhosphorIcons.shieldCheck(PhosphorIconsStyle.regular),
    'I20': PhosphorIcons.hamburger(PhosphorIconsStyle.regular),
    'I21': PhosphorIcons.pizza(PhosphorIconsStyle.regular),
    'I22': PhosphorIcons.musicNote(PhosphorIconsStyle.regular),
    'I23': PhosphorIcons.videoCamera(PhosphorIconsStyle.regular),
    'I24': PhosphorIcons.ticket(PhosphorIconsStyle.regular),
    'I25': PhosphorIcons.globe(PhosphorIconsStyle.regular),
    'I26': PhosphorIcons.calendarBlank(PhosphorIconsStyle.regular),
    'I27': PhosphorIcons.penNib(PhosphorIconsStyle.regular),
    'I28': PhosphorIcons.deviceMobile(PhosphorIconsStyle.regular),
    'I29': PhosphorIcons.firstAidKit(PhosphorIconsStyle.regular),
    'I30': PhosphorIcons.plugCharging(PhosphorIconsStyle.regular),
    'I31': PhosphorIcons.trophy(PhosphorIconsStyle.regular),
    'I32': PhosphorIcons.treePalm(PhosphorIconsStyle.regular),
    'I33': PhosphorIcons.camera(PhosphorIconsStyle.regular),
    'I34': PhosphorIcons.bugBeetle(PhosphorIconsStyle.regular),
    'I35': PhosphorIcons.dress(PhosphorIconsStyle.regular),
    'I36': PhosphorIcons.armchair(PhosphorIconsStyle.regular),
    'I37': PhosphorIcons.trash(PhosphorIconsStyle.regular),
    'I38': PhosphorIcons.tag(PhosphorIconsStyle.regular),
    'I39': PhosphorIcons.currencyDollar(PhosphorIconsStyle.regular),
    'I40': PhosphorIcons.handCoins(PhosphorIconsStyle.regular),
    'I41': PhosphorIcons.shoppingBag(PhosphorIconsStyle.regular),
    'I42': PhosphorIcons.phoneCall(PhosphorIconsStyle.regular),
    'I43': PhosphorIcons.notePencil(PhosphorIconsStyle.regular),
    'I44': PhosphorIcons.coins(PhosphorIconsStyle.regular),
    'I45': PhosphorIcons.paintBrush(PhosphorIconsStyle.regular),
    'I46': PhosphorIcons.bus(PhosphorIconsStyle.regular),
    'I47': PhosphorIcons.gameController(PhosphorIconsStyle.regular),
    'I48': PhosphorIcons.currencyCircleDollar(PhosphorIconsStyle.regular),
    'I49': PhosphorIcons.package(PhosphorIconsStyle.regular),
    'I50': PhosphorIcons.jeep(PhosphorIconsStyle.regular),
    'I51': PhosphorIcons.laptop(PhosphorIconsStyle.regular),
    'I52': PhosphorIcons.lego(PhosphorIconsStyle.regular),
    'I53': PhosphorIcons.motorcycle(PhosphorIconsStyle.regular),
    'I54': PhosphorIcons.popcorn(PhosphorIconsStyle.regular),
    'I55': PhosphorIcons.spotifyLogo(PhosphorIconsStyle.regular),
    'I56': PhosphorIcons.taxi(PhosphorIconsStyle.regular),
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
        categoriasBanco = controller.categories
            .where((cat) => cat.isArchived != true)
            .toList(); // aplica o filtro aqui
      });
    } else {
      print('Erro ao carregar categorias do banco: $res');
      FloatingMessage(context, 'Erro ao carregar categorias', 'error', 2);
    }
  }

  Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // alpha default
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

  void _abrirModalCategorias() {
    TextEditingController searchController = TextEditingController();
    List<CategoryTransactionModel> categoriasFiltradas = [...categoriasBanco];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.dynamicModalColor(context),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          void filtrar(String valor) {
            setModalState(() {
              categoriasFiltradas = categoriasBanco
                  .where((cat) =>
                      cat.name.toLowerCase().contains(valor.toLowerCase()))
                  .toList();
            });
          }

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: 400,
              child: Column(
                children: [
                  // Barra de arrastar
                  Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  // Título
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'Selecionar categoria',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Campo busca
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar categoria...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: filtrar,
                    ),
                  ),
                  // Lista
                  Expanded(
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: categoriasFiltradas.length +
                          1, // +1 para botão adicionar
                      separatorBuilder: (_, __) =>
                          Divider(color: Colors.grey.shade300),
                      itemBuilder: (_, index) {
                        if (index < categoriasFiltradas.length) {
                          final cat = categoriasFiltradas[index];
                          final nome = cat.name;
                          final tipo = cat.type;
                          final cor = obterCorCategoria(nome);
                          final icone = iconesPorTipo[tipo] ?? Iconsax.note;

                          return ListTile(
                            onTap: () {
                              setState(() {
                                categoriaSelecionada = nome;
                                tipoSelecionado = tipo;
                              });
                              widget.onCategoriaSelecionada(nome, tipo, cor);
                              Navigator.pop(context);
                            },
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: cor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icone,
                                  color: AppTheme.dynamicIconColor(cor)),
                            ),
                            title: Text(nome),
                            trailing: categoriaSelecionada == nome
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : null,
                          );
                        }
                        if (index == categoriasFiltradas.length) {
                          return ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              final resultado =
                                  await Navigator.of(context).push<bool>(
                                MaterialPageRoute(
                                  builder: (_) => const CriarCategoriaScreen(),
                                ),
                              );
                              if (resultado == true) {
                                await carregarCategoriasBanco();
                                _abrirModalCategorias();
                              }
                            },
                            leading: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            title: const Text(
                              'Adicionar nova categoria',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _abrirTelaCriarCategoria() async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (_) => const CriarCategoriaScreen(),
      ),
    );

    // Se criou uma categoria com sucesso, recarregue categorias
    if (resultado == true) {
      await carregarCategoriasBanco();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _abrirModalCategorias,
          child: Container(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
            color: AppTheme.dynamicCardColor(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: categoriaSelecionada != null
                          ? obterCorCategoria(categoriaSelecionada!)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      ),
                  child: Icon(
                    categoriaSelecionada != null
                        ? (iconesPorTipo[tipoSelecionado ?? ''] ?? Iconsax.note)
                        : Iconsax.category,
                    color: categoriaSelecionada != null ? AppTheme.dynamicIconColor(obterCorCategoria(categoriaSelecionada!)) : AppTheme.dynamicTextColor(context),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    categoriaSelecionada ?? 'Selecione uma categoria',
                    style: TextStyle(
                      fontSize: 16,
                      color: categoriaSelecionada != null
                          ? AppTheme.dynamicTextColor(context)
                          : AppTheme.dynamicTextColor(context),
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
