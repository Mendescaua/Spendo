import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/utils/theme.dart';

class MetaStep extends ConsumerStatefulWidget {
  final VoidCallback? onFinished;

  const MetaStep({super.key, this.onFinished});

  @override
  ConsumerState<MetaStep> createState() => _MetaStepState();
}

class _MetaStepState extends ConsumerState<MetaStep> {
  final _formKey = GlobalKey<FormState>();

  List<String> motivosSelecionados = [];

  final List<Map<String, dynamic>> motivos = [
    {
      'texto': 'Economizar dinheiro',
      'icone': PhosphorIcons.currencyDollarSimple(PhosphorIconsStyle.regular),
    },
    {
      'texto': 'Controlar meus gastos',
      'icone': PhosphorIcons.chartLineUp(PhosphorIconsStyle.regular),
    },
    {
      'texto': 'Melhorar minha qualidade de vida',
      'icone': PhosphorIcons.heart(PhosphorIconsStyle.regular),
    },
    {
      'texto': 'Sair das dívidas',
      'icone': PhosphorIcons.warningCircle(PhosphorIconsStyle.regular),
    },
    {
      'texto': 'Entender onde gasto mais',
      'icone': PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular),
    },
  ];

  void _atualizarMotivos(String motivo, bool selecionado) {
    setState(() {
      if (selecionado) {
        motivosSelecionados.remove(motivo);
      } else {
        motivosSelecionados.add(motivo);
      }

      // Quando pelo menos um motivo for selecionado, aciona onFinished
      if (motivosSelecionados.isNotEmpty) {
        widget.onFinished?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Por que você quer usar o Spendo?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...motivos.map((item) {
              final String motivo = item['texto'];
              final IconData icone = item['icone'];

              final bool selecionado = motivosSelecionados.contains(motivo);

              return GestureDetector(
                onTap: () => _atualizarMotivos(motivo, selecionado),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.dynamicCardColor(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selecionado
                          ? Theme.of(context).colorScheme.primary
                          : AppTheme.dynamicBorderSavingColor(context),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.primaryColor,
                        ),
                        child: Icon(
                          icone,
                          size: 26,
                          color: AppTheme.whiteColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          motivo,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                selecionado ? FontWeight.bold : FontWeight.w400,
                            color: AppTheme.dynamicTextColor(context),
                          ),
                        ),
                      ),
                      Checkbox(
                        value: selecionado,
                        onChanged: (bool? value) {
                          _atualizarMotivos(motivo, selecionado);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
