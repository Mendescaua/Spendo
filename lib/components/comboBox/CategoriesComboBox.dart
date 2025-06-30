import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/ui/add_category_screen.dart';
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

  void _abrirModalCategorias() async {
    await showModalBottomSheet(
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
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: categoriasBanco.length + 1, // +1 para o botão
                  separatorBuilder: (_, __) =>
                      Divider(color: Colors.grey.shade300),
                  itemBuilder: (_, index) {
                    if (index < categoriasBanco.length) {
                      final cat = categoriasBanco[index];
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
                          child: Icon(icone, color: Colors.white),
                        ),
                        title: Text(nome),
                        trailing: categoriaSelecionada == nome
                            ? const Icon(Icons.check_circle,
                                color: Colors.green)
                            : null,
                      );
                    } else {
                      // Último item: botão "Adicionar categoria"
                      return ListTile(
                        onTap: () async {
                          Navigator.pop(context); // Fecha modal seleção

                          final resultado =
                              await Navigator.of(context).push<bool>(
                            MaterialPageRoute(
                              builder: (_) => const CriarCategoriaScreen(),
                            ),
                          );

                          if (resultado == true) {
                            await carregarCategoriasBanco();
                            // Reabre modal seleção para continuar com a nova categoria visível
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
                  },
                ),
              ),
            ],
          ),
        );
      },
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.grey.shade600,
                width: 1,
              ),
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
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    categoriaSelecionada != null
                        ? (iconesPorTipo[tipoSelecionado ?? ''] ?? Iconsax.note)
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
      ],
    );
  }
}
