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
  final TextEditingController _valorController = TextEditingController();

  List<String> motivosSelecionados = [];

  final List<String> motivos = [
    'Economizar dinheiro',
    'Controlar meus gastos',
    'Planejar uma viagem',
    'Sair das dívidas',
    'Entender onde gasto mais',
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

            ...motivos.map((motivo) {
              final selecionado = motivosSelecionados.contains(motivo);

              return GestureDetector(
                onTap: () => _atualizarMotivos(motivo, selecionado),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.dynamicCardColor(context),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selecionado
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade300,
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
                          color: selecionado
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : Colors.grey.shade200,
                        ),
                        child: Icon(
                          PhosphorIcons.target(PhosphorIconsStyle.regular),
                          size: 26,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          motivo,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: selecionado ? FontWeight.bold : FontWeight.w400,
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
