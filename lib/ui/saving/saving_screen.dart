import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/SavingBigCard.dart';
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
    Future.microtask(() => loadSaving());
  }

  Future<void> loadSaving() async {
    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(savingControllerProvider.notifier);
    final result = await controller.getSaving();

    setState(() => _loading = false);

    if (result != null) {
      print('Erro ao carregar cofrinhos: $result');
    }
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
                    child: const Modalsaving(
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
    final savings = ref.watch(
        savingControllerProvider); // Usando o provider para obter os cofrinhos, sem precisar carregar a tela novamente
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cofrinhos"),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
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
                              "Nenhum cofrinho encontrada",
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        : ListView.builder(
                            itemCount: savings.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                  key: Key(savings[index].id.toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    margin: const EdgeInsets.only(
                                        bottom: 16, right: 16),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(
                                          16), // igual ao do seu SubscriptionCard
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white),
                                  ),
                                  onDismissed: (direction) {
                                    onDelete(savings[index].id!);
                                  },
                                  child: Savingbigcard(saving: savings[index]));
                            },
                          ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddTransactionModal(context);
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
