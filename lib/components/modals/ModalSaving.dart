import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/saving_controller.dart';
import 'package:spendo/models/saving_model.dart';
import 'package:spendo/utils/theme.dart';

class Modalsaving extends ConsumerStatefulWidget {
  SavingModel? saving;
  final String type;
  Modalsaving({super.key, required this.type, this.saving});

  @override
  ConsumerState<Modalsaving> createState() => _ModalsavingState();
}

class _ModalsavingState extends ConsumerState<Modalsaving> {
  final TextEditingController _titlecontroller = TextEditingController();
  String? selectedImageUrl;

  final _goalvaluecontroller = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );

  final _valuecontroller = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    leftSymbol: 'R\$ ',
  );


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final savingController = ref.read(savingControllerProvider.notifier);

    void onSave() async {
      final response = await savingController.addSaving(
        saving: SavingModel(
          title: _titlecontroller.text,
          goalValue: _goalvaluecontroller.numberValue,
          picture: selectedImageUrl ?? '',
        ),
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(context, 'Meta adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    void onUpdateValue() async {
      final response = await savingController.updateSavingValue(
        saving: SavingModel(
          id: widget.saving!.id,
          value: _valuecontroller.numberValue,
        ),
        type: widget.type,
      );
      if (response != null) {
        FloatingMessage(context, response, 'error', 2);
      } else {
        FloatingMessage(context, 'Valor adicionada com sucesso', 'success', 2);
        Navigator.of(context).pop();
      }
    }

    return SafeArea(
      child: widget.type == 'retirar' || widget.type == 'adicionar'
          ? SingleChildScrollView(
            padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
            child: Container(
              decoration: BoxDecoration(
          color: AppTheme.dynamicModalColor(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                width: double.infinity,
                height: size.height * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
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
                    Center(
                      child: Text(
                        widget.type == 'retirar'
                            ? 'Retirar valor do cofrinho'
                            : 'Adicionar novo valor ao cofrinho',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                    SizedBox(height: 4),
                    StyleButton(
                        text: widget.type == 'retirar' ? 'Retirar' : 'Adicionar',
                        onClick: () {
                          onUpdateValue();
                        }),
                  ],
                ),
              ),
          )
          : SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                width: double.infinity,
                height: size.height * 0.66,
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
                    GestureDetector(
                      onTap: () async {
                        final selectedImage = await Navigator.of(context)
                            .pushNamed('/saving_picker_image');
            
                        if (selectedImage != null && selectedImage is String) {
                          setState(() {
                            selectedImageUrl = selectedImage;
                          });
                          print('Imagem escolhida: $selectedImage');
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: selectedImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(selectedImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: selectedImageUrl == null ? Colors.grey : null,
                        ),
                        child: selectedImageUrl == null
                            ? const Icon(
                                Iconsax.gallery_add,
                                size: 42,
                                color: Colors.white,
                              )
                            : null,
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
                    SizedBox(height: 32),
                    StyleButton(
                        text: 'Adicionar',
                        onClick: () {
                          onSave();
                        }),
                  ],
                ),
              ),
          ),
    );
  }
}
