import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
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
  String? tipoSelecionado; // armazena o tipo da categoria selecionada

  // Ícones disponíveis com tipo associado (exemplo: 'I' para investimento)
  final List<Map<String, dynamic>> iconesDisponiveis = [
    {'icone': Iconsax.activity, 'tipo': 'A'},
    {'icone': Iconsax.money, 'tipo': 'M'},
    {'icone': Iconsax.chart, 'tipo': 'I'},
    {'icone': Iconsax.note, 'tipo': 'N'},
    {'icone': Iconsax.wallet_2, 'tipo': 'P'},
    {'icone': Iconsax.gift, 'tipo': 'G'},
    {'icone': Iconsax.star, 'tipo': 'S'},
    {'icone': Iconsax.heart, 'tipo': 'H'},
    {'icone': Iconsax.home, 'tipo': 'O'},
    // Adicione mais aqui conforme quiser
  ];

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

  void onSave(String nomeNovaCategoria, String tipoNovaCategoria) async {
    final controller = ref.read(transactionControllerProvider.notifier);
    final resposta = await controller.addCategoryTransaction(
      transaction: CategoryTransactionModel(
        name: nomeNovaCategoria,
        type: tipoNovaCategoria,
        uuid: '', // o controller seta o uuid
      ),
    );
    if (resposta != null) {
      FloatingMessage(context, resposta, 'error', 2);
    } else {
      FloatingMessage(
          context, 'Categoria adicionada com sucesso', 'success', 2);
      await carregarCategoriasBanco(); // recarrega categorias do banco
    }
  }

  Future<void> _abrirDialogCriarCategoria(BuildContext context) async {
    String nomeNovaCategoria = '';
    IconData? iconeSelecionado;
    String? tipoSelecionadoDialog;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
            title: const Text('Criar nova categoria'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  autofocus: true,
                  decoration:
                      const InputDecoration(hintText: 'Nome da categoria'),
                  onChanged: (value) {
                    nomeNovaCategoria = value.trim();
                  },
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  children: iconesDisponiveis.map((item) {
                    final icone = item['icone'] as IconData;
                    final tipo = item['tipo'] as String;
                    final isSelected = iconeSelecionado == icone;
                    return GestureDetector(
                      onTap: () {
                        setStateDialog(() {
                          iconeSelecionado = icone;
                          tipoSelecionadoDialog = tipo;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.primaryColor.withOpacity(0.3)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: AppTheme.primaryColor, width: 2)
                              : Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          icone,
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey[600],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nomeNovaCategoria.isEmpty ||
                      tipoSelecionadoDialog == null) return;
                  onSave(nomeNovaCategoria, tipoSelecionadoDialog!);

                  // Atualiza localmente as categorias fixas para aparecer no modal
                  setState(() {
                    categoriasFixasComIcones[nomeNovaCategoria] =
                        iconeSelecionado!;
                    coresCategoria[nomeNovaCategoria] =
                        Colors.grey; // pode personalizar cor
                    categoriaSelecionada = nomeNovaCategoria;
                    tipoSelecionado = tipoSelecionadoDialog;
                  });

                  widget.onCategoriaSelecionada(
                      nomeNovaCategoria, tipoSelecionadoDialog!);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _abrirModalCategorias(BuildContext context) {
    // Combina categorias fixas e categorias do banco
    final Map<String, IconData> todasCategoriasComIcones = {
      ...categoriasFixasComIcones,
      // Para as categorias do banco, tenta usar o ícone fixo se tiver, ou um default
      for (var cat in categoriasBanco)
        cat.name: categoriasFixasComIcones[cat.name] ?? Iconsax.note,
    };

    // Para mapear tipos de categorias do banco
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Iconsax.add_circle),
                label: const Text('Criar nova categoria'),
                onPressed: () => _abrirDialogCriarCategoria(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: todasCategoriasComIcones.entries.map((entry) {
                  final nome = entry.key;
                  final icone = entry.value;
                  final cor = coresCategoria[nome] ?? AppTheme.primaryColor;
                  final tipoDaCategoria = tiposCategoriasBanco[nome] ??
                      (iconesDisponiveis.firstWhere(
                        (item) => item['icone'] == icone,
                        orElse: () => {'tipo': 'T'},
                      )['tipo'] as String);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              color: cor.withOpacity(0.2),
                            ),
                            child: Icon(icone, color: cor),
                          ),
                          title: Text(
                            nome,
                            style: const TextStyle(fontSize: 16),
                          ),
                          trailing: nome == categoriaSelecionada
                              ? const Icon(Icons.check, color: Colors.green)
                              : null,
                          onTap: () {
                            setState(() {
                              categoriaSelecionada = nome;
                              tipoSelecionado = tipoDaCategoria;
                            });
                            widget.onCategoriaSelecionada(
                                nome, tipoDaCategoria);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final texto = categoriaSelecionada ?? "Selecionar categoria";

    return InkWell(
      onTap: () => _abrirModalCategorias(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppTheme.ShadowTextColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              texto,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Icon(Iconsax.arrow_down_1),
          ],
        ),
      ),
    );
  }
}
