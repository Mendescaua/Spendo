import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/ColorPickerField.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/saving_controller.dart';
import 'package:spendo/models/saving_model.dart';

class Modalsaving extends ConsumerStatefulWidget {
  final String type;
  const Modalsaving({super.key, required this.type});

  @override
  ConsumerState<Modalsaving> createState() => _ModalsavingState();
}

class _ModalsavingState extends ConsumerState<Modalsaving> {
  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _goalvaluecontroller = TextEditingController();
  final TextEditingController _valuecontroller = TextEditingController();
  String _color = '#FF4678c0';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final savingController = ref.read(savingControllerProvider.notifier);

    void onSave() async {
      final response = await savingController.addSaving(
        subscription: SavingModel(
          title: _titlecontroller.text,
          goalValue: double.tryParse(_goalvaluecontroller.text) ?? 0.0,
          colorCard: _color,
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(
            context, 'Cofrinho adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    void onAddValue() async {
      final response = await savingController.addSaving(
        subscription: SavingModel(
          value: double.tryParse(_valuecontroller.text) ?? 0.0,
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(context, 'Valor adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    return SafeArea(
      child: widget.type == 'add value'
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              width: double.infinity,
              height: size.height * 0.36,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: const Text(
                      'Adicionar novo valor ao cofrinho',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Valor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: _valuecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.dollar_circle),
                      hintText: 'Valor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  StyleButton(
                      text: 'Adicionar',
                      onClick: () {
                        onAddValue();
                      }),
                ],
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
              width: double.infinity,
              height: size.height * 0.54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: const Text(
                      'Adicionar novo cofrinho',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Título',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: _titlecontroller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.text_block),
                      hintText: 'Título',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  const Text(
                    'Meta de valor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: _goalvaluecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.dollar_circle),
                      hintText: 'Meta de valor',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ColorPickerField(
                    initialColorHex: '#FF4678c0',
                    onColorSelected: (colorHex) {
                      _color = colorHex;
                      print('Cor selecionada: $colorHex');
                    },
                  ),
                  SizedBox(height: 32),
                  StyleButton(
                      text: 'Adicionar',
                      onClick: () {
                        onSave();
                      }),
                ],
              ),
            ),
    );
  }
}
