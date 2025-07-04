import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendo/components/ColorPickerCarousel.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/IconPickerCarousel.dart';
import 'package:spendo/controllers/transaction_controller.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/theme.dart';

class ModalCategory extends ConsumerStatefulWidget {
  final CategoryTransactionModel category;
  const ModalCategory({Key? key, required this.category}) : super(key: key);

  @override
  ConsumerState<ModalCategory> createState() => _ModalCategoryState();
}

class _ModalCategoryState extends ConsumerState<ModalCategory> {
  late TextEditingController nameController;
  late String selectedColorHex;
  IconData? iconeSelecionado;
  String? tipoSelecionadoDialog;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.category.name);
    selectedColorHex = widget.category.color ?? '#FF2196F3';
    tipoSelecionadoDialog = widget.category.type;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> onUpdateValue() async {
    final transactionController = ref.read(transactionControllerProvider.notifier);

    print(nameController.text);

    final response = await transactionController.updateCategoryTransaction(
      newColor: selectedColorHex,
      newName: nameController.text,
      newType: tipoSelecionadoDialog,

      category: CategoryTransactionModel(
        id: widget.category.id,
        name: widget.category.name,
        color: widget.category.color,
        type:   widget.category.type,
      ),
    );
    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
      // ou ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
    } else {
      FloatingMessage(context, 'Categoria editada com sucesso', 'success', 2);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 24),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxHeight: size.height * 0.75,
          ),
          decoration: BoxDecoration(
            color: AppTheme.dynamicModalColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Editar categoria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Nome',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Categoria',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF4678c0)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ColorPickerCarousel(
                initialColorHex: selectedColorHex,
                onColorSelected: (colorHex) {
                  setState(() {
                    selectedColorHex = colorHex;
                    print('selectedColorHex: $selectedColorHex');
                  });
                },
              ),
              const SizedBox(height: 24),
              IconPickerCarousel(
                selectedTipo: tipoSelecionadoDialog,
                selectedColor: Color(int.parse(selectedColorHex.replaceFirst('#', '0xff'))),
                onIconSelected: (icon, tipoSelecionado) {
                  setState(() {
                    iconeSelecionado = icon;
                    tipoSelecionadoDialog = tipoSelecionado;
                    print('tipoSelecionadoDialog: $tipoSelecionadoDialog');
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onUpdateValue,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
