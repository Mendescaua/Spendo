import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:spendo/components/transactionContainer.dart';
import 'package:spendo/models/category_transaction_model.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class CategoryCard extends StatelessWidget {
  final CategoryTransactionModel category;
  final Function()? onArquivar;
  final Function()? onEditar;

  const CategoryCard({
    Key? key,
    required this.category,
    this.onArquivar,
    this.onEditar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          TransactionContainer(
            type: category.type ?? '',
            color: category.color ?? '',
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              Customtext.capitalizeFirstLetter(category.name),
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppTheme.dynamicTextColor(context),
              ),
            ),
          ),
          SpeedDial(
            elevation: 0,
            animationCurve: Curves.easeInOut,
            animationDuration:const Duration(milliseconds: 250), // tempo da animação
            icon: PhosphorIcons.dotsThreeVertical(PhosphorIconsStyle.regular),
            iconTheme: IconThemeData(color: AppTheme.dynamicTextColor(context)),
            activeIcon: PhosphorIcons.x(PhosphorIconsStyle.regular),
            buttonSize: const Size(36, 36),
            childrenButtonSize: const Size(50, 60),
            backgroundColor: AppTheme.dynamicCardColor(context),
            activeBackgroundColor: AppTheme.dynamicCardColor(context),
            activeForegroundColor: AppTheme.dynamicTextColor(context),
            overlayColor: Colors.black,
            overlayOpacity: 0.3, // Escurece o fundo quando aberto
            direction: SpeedDialDirection.down, // Botões aparecem abaixo
            spacing: 6,
            children: [
              SpeedDialChild(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12), 
                ),
                child: Icon(
                    PhosphorIcons.trayArrowDown(PhosphorIconsStyle.regular),
                    color: Colors.white,
                    size: 32),
                backgroundColor: const Color.fromARGB(255, 228, 191, 28),
                label: 'Arquivar',
                labelStyle: const TextStyle(fontSize: 12),
                onTap: onArquivar ??
                    () {
                      print('Arquivar categoria ${category.name}');
                    },
              ),
              SpeedDialChild(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      12), 
                ),
                child: Icon(
                    PhosphorIcons.notePencil(PhosphorIconsStyle.regular),
                    color: Colors.white,
                    size: 32),
                backgroundColor: Colors.blue,
                label: 'Editar',
                labelStyle: const TextStyle(fontSize: 12),
                onTap: onEditar ??
                    () {
                      print('Editar categoria ${category.name}');
                    },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
