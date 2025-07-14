import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/ConfirmAlertDialog.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/MoneyCard.dart';
import 'package:spendo/controllers/money_card_controller.dart';
import 'package:spendo/utils/theme.dart';

class MoneyCardScreen extends ConsumerStatefulWidget {
  const MoneyCardScreen({super.key});

  @override
  ConsumerState<MoneyCardScreen> createState() => _MoneyCardScreenState();
}

class _MoneyCardScreenState extends ConsumerState<MoneyCardScreen> {
  void onDelete(int id) async {
    final controller = ref.read(moneyCardControllerProvider.notifier);
    final response = await controller.deleteMoneyCard(id: id);

    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      FloatingMessage(context, 'Cartão deletado com sucesso', 'success', 2);
    }
  }

  Future<void> onReorder(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    final controller = ref.read(moneyCardControllerProvider.notifier);
    final cards = [...ref.read(moneyCardControllerProvider)];

    final movedCard = cards.removeAt(oldIndex);
    cards.insert(newIndex, movedCard);

    // Atualiza o estado local para refletir a mudança imediatamente
    controller.state = cards;

    // Atualiza a ordem no banco para cada cartão
    for (int i = 0; i < cards.length; i++) {
      await controller.updateCardOrder(cards[i].id!, i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(moneyCardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartões'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Iconsax.arrow_left, color: Colors.white),
        ),
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.dynamicBackgroundColor(context),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: cards.isEmpty
            ? const Center(child: Text("Nenhum cartão encontrado"))
            : ReorderableListView.builder(
                itemCount: cards.length,
                onReorder: onReorder,
                buildDefaultDragHandles: false,
                proxyDecorator:
                    (Widget child, int index, Animation<double> animation) {
                  return Material(
                    elevation: 6,
                    color: Colors.transparent,
                    shadowColor: Colors.black54,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width -
                          32, // largura do card
                      child: child,
                    ),
                  );
                },
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Dismissible(
                    key: Key(card.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      bool? confirmed = await showDialog<bool>(
                        context: context,
                        builder: (_) => ConfirmDeleteDialog(
                          label: 'Cartão',
                          onConfirm: () {
                            Navigator.of(context)
                                .pop(true); // Retorna true para o Dismissible
                          },
                        ),
                      );
                      return confirmed ?? false;
                    },
                    onDismissed: (direction) {
                      onDelete(card.id!);
                    },
                    background: Container(
                      margin:
                          const EdgeInsets.only(bottom: 20, right: 18, top: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
                      key: ValueKey(card.id),
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: _HoldToDrag(
                              index: index,
                              child: MoneyCard(cards: card),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add_money_card');
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class _HoldToDrag extends StatelessWidget {
  final Widget child;
  final int index;

  const _HoldToDrag({
    required this.child,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<int>(
      data: index,
      axis: Axis.vertical,
      delay: const Duration(seconds: 2), // Espera 2 segundos
      onDragStarted: () {
        HapticFeedback.mediumImpact(); // Vibra ao entrar no modo de arraste
      },
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: child,
        ),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: ReorderableDelayedDragStartListener(
        index: index,
        child: child,
      ),
    );
  }
}
