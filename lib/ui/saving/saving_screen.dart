import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/BackToHomeWrapper.dart';
import 'package:spendo/components/ConfirmAlertDialog.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/SavingCard.dart';
import 'package:spendo/components/modals/ModalSaving.dart';
import 'package:spendo/controllers/saving_controller.dart';
import 'package:spendo/utils/theme.dart';

class SavingScreen extends ConsumerStatefulWidget {
  const SavingScreen({super.key});

  @override
  ConsumerState<SavingScreen> createState() => _SavingScreenState();
}

class _SavingScreenState extends ConsumerState<SavingScreen> {
  bool _loading = false;

  @override
  void initState() {
    super.initState();
  }

  void onDelete(int id) async {
    final controller = ref.read(savingControllerProvider.notifier);
    final response = await controller.deleteSaving(id: id);

    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      FloatingMessage(context, 'Cofrinho deletada com sucesso', 'success', 2);
    }
  }

  void _openAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: Modalsaving(
                      type: 'add saving',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final savings = ref.watch(savingControllerProvider);
    return BackToHomeWrapper(
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          title: const Text(
            "Minhas metas",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left, color: Colors.white),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/menu'),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                decoration: BoxDecoration(
                  color: AppTheme.dynamicBackgroundColor(context),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: _loading
                    ? Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppTheme.primaryColor,
                          size: 64,
                        ),
                      )
                    : savings.isEmpty
                        ? const Center(
                            child: Text(
                              "Nenhuma meta encontrado",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: savings.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(savings[index].id.toString()),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  bool? confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => ConfirmDeleteDialog(
                                      label: 'meta',
                                      onConfirm: () {
                                        Navigator.of(context).pop(
                                            true); // Retorna true para o Dismissible
                                      },
                                    ),
                                  );
                                  return confirmed ?? false;
                                },
                                onDismissed: (direction) {
                                  onDelete(savings[index].id!);
                                },
                                background: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 18, right: 16, top: 2),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  alignment: Alignment.centerRight,
                                  child: const Icon(Iconsax.trash,
                                      color: Colors.white),
                                ),
                                child: MetaCard(
                                  saving: savings[index],
                                ),
                              );
                            },
                          ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddTransactionModal(context),
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
      ),
    );
  }
}
