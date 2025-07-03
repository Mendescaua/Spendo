import 'package:flutter/material.dart';
import 'package:spendo/components/ColorPickerCarousel.dart';
import 'package:spendo/components/IconPickerCarousel.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

void ModalCategory(BuildContext context,
    {required CategoryTransactionModel category}) {
  // Controlador para o TextField para poder editar o nome se quiser depois
  final TextEditingController nameController =
      TextEditingController(text: category.name);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      String selectedColorHex =
          category.color ?? '#FF2196F3'; // cor padrão caso category não tenha
      IconData? iconeSelecionado;
      String? tipoSelecionadoDialog = category.type;

      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.dynamicModalColor(context),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Center(
                        child: Text(
                          'Editar categoria',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Nome',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Categoria',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide:
                                const BorderSide(color: Color(0xFF4678c0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ColorPickerCarousel(
                        initialColorHex: selectedColorHex,
                        onColorSelected: (colorHex) {
                          setState(() {
                            selectedColorHex = colorHex;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      IconPickerCarousel(
                        selectedTipo: category.type, // por exemplo 'I04'
                        selectedColor: category.color != null
                            ? Color(int.parse(
                                category.color.replaceFirst('#', '0xff')))
                            : const Color(0xFF2196F3),
                        onIconSelected: (icon, tipoSelecionado) {
                          setState(() {
                            iconeSelecionado = icon;
                            tipoSelecionadoDialog = tipoSelecionado;
                            
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Salvar'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
