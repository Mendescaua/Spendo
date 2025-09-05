import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class CategoryStep extends ConsumerStatefulWidget {
  final VoidCallback? onSaved;
  const CategoryStep({super.key, this.onSaved});

  @override
  ConsumerState<CategoryStep> createState() => _CategoryStepState();
}

class _CategoryStepState extends ConsumerState<CategoryStep> {
  final List<Map<String, dynamic>> categoriasPreDefinidas = [
    {
      'nome': 'Alimentação',
      'icone': PhosphorIcons.forkKnife(PhosphorIconsStyle.regular),
      'tipo': 'I01',
      'cor': Color(0xFF42A5F5),
    },
    {
      'nome': 'Transporte',
      'icone': PhosphorIcons.bus(PhosphorIconsStyle.regular),
      'tipo': 'I46',
      'cor': Color(0xFFFFA726),
    },
    {
      'nome': 'Lazer',
      'icone': PhosphorIcons.musicNote(PhosphorIconsStyle.regular),
      'tipo': 'I22',
      'cor': Color(0xFFBA68C8),
    },
    {
      'nome': 'Casa',
      'icone': PhosphorIcons.house(PhosphorIconsStyle.regular),
      'tipo': 'I10',
      'cor': Color(0xFF4CAF50),
    },
    {
      'nome': 'Educação',
      'icone': PhosphorIcons.bookOpen(PhosphorIconsStyle.regular),
      'tipo': 'I12',
      'cor': Color(0xFFFF7043),
    },
  ];

  final List<String> selecionadas = [];

  Future<void> onSalvarCategorias() async {
    final controller = ref.read(transactionControllerProvider.notifier);

    for (final categoria in categoriasPreDefinidas) {
      if (selecionadas.contains(categoria['tipo'])) {
        final corHex =
            '#${(categoria['cor'] as Color).value.toRadixString(16).padLeft(8, '0')}';

        final resposta = await controller.addCategoryTransaction(
          transaction: CategoryTransactionModel(
            name: categoria['nome'],
            type: categoria['tipo'],
            color: corHex,
          ),
        );

        if (resposta != null) {
          FloatingMessage(context, resposta, 'error', 2);
          return;
        }
      }
    }

    FloatingMessage(context, 'Categorias salvas com sucesso', 'success', 2);

    // Notifica o pai que salvou com sucesso
    widget.onSaved?.call();
  }

  @override
  Widget build(BuildContext context) {
    final selecionadasCount = selecionadas.length;
    final podeSelecionarMais = selecionadasCount < 5;
    final botaoAtivo = selecionadasCount >= 3;

    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.dynamicBackgroundColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Escolha 3 ou mais categorias de gastos para começar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: categoriasPreDefinidas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final categoria = categoriasPreDefinidas[index];
                    final selecionado =
                        selecionadas.contains(categoria['tipo']);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selecionado) {
                            selecionadas.remove(categoria['tipo']);
                          } else {
                            if (podeSelecionarMais) {
                              selecionadas.add(categoria['tipo']);
                            } else {
                              FloatingMessage(
                                context,
                                'Você só pode selecionar até 5 categorias',
                                'error',
                                2,
                              );
                            }
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        decoration: BoxDecoration(
                          color: selecionado
                              ? (categoria['cor'] as Color).withOpacity(0.9)
                              : AppTheme.dynamicCardColor(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selecionado
                                ? AppTheme.primaryColor
                                : AppTheme.dynamicBorderSavingColor(context),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              categoria['icone'],
                              size: 28,
                              color: AppTheme.dynamicTextColor(context),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              categoria['nome'],
                              style: TextStyle(
                                fontSize: 16,
                                color: selecionado
                                    ? Colors.white
                                    : AppTheme.dynamicTextColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            if (selecionado)
                              const Icon(Icons.check, color: Colors.white),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              StyleButton(
                text: 'Próximo',
                onClick: botaoAtivo
                    ? () async {
                        await onSalvarCategorias();
                      }
                    : null,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
