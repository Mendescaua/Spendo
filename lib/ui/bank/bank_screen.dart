import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/cards/BankLoadedCard.dart';
import 'package:spendo/components/modals/ModalBank.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/utils/theme.dart';

class BankScreen extends ConsumerStatefulWidget {
  const BankScreen({super.key});

  @override
  ConsumerState<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends ConsumerState<BankScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBanks();
  }

  Future<void> _loadBanks() async {
    setState(() => _isLoading = true);
    final controller = ref.read(bankControllerProvider.notifier);
    await controller.getBank();
    setState(() => _isLoading = false);
  }

  void onDelete(int id) async {
    final controller = ref.read(bankControllerProvider.notifier);
    final response = await controller.deleteBank(id: id);

    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      FloatingMessage(context, 'Conta deletada com sucesso', 'success', 2);
    }
  }

  Future<void> _openAddBank(BuildContext context) async {
    await showModalBottomSheet(
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
                    child: ModalBank(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await _loadBanks(); // recarrega após fechar modal
  }

  @override
  Widget build(BuildContext context) {
    final banks = ref.watch(bankControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas contas'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          color: AppTheme.whiteColor,
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Voltar',
        ),
        actions: [
          IconButton(
            icon: Icon(PhosphorIcons.question(PhosphorIconsStyle.regular), size: 28, color: AppTheme.whiteColor,),
            onPressed: () {
              FloatingMessage(context, "Segure e arraste para reordenar ou arraste para esquerda para excluir", 'info', 6);
            },
          )
        ],
      ),
      backgroundColor: AppTheme.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ReorderableListView.builder(
                      proxyDecorator: (Widget child, int index,
                          Animation<double> animation) {
                        return Material(
                          color: Colors.transparent,
                          elevation: 0, // remove sombra
                          child: child,
                        );
                      },
                      onReorder: (oldIndex, newIndex) async {
                        if (newIndex > oldIndex) newIndex -= 1;
                        final newBanks = List.of(banks);
                        final item = newBanks.removeAt(oldIndex);
                        newBanks.insert(newIndex, item);

                        // Vibration ao reordenar
                        HapticFeedback.mediumImpact();

                        await ref
                            .read(bankControllerProvider.notifier)
                            .updateOrder(newBanks);
                      },
                      itemCount: banks.length,
                      itemBuilder: (context, index) {
                        final bank = banks[index];
                        return Dismissible(
                          key: ValueKey(bank.id),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: const Text(
                                    'Você realmente deseja excluir essa conta?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Excluir',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                          },
                          background: Container(
                            margin: const EdgeInsets.only(
                                bottom: 16, right: 16, top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            alignment: Alignment.centerRight,
                            child:
                                const Icon(Icons.delete, color: Colors.white),
                          ),
                          onDismissed: (direction) {
                            onDelete(bank.id!);
                          },
                          child: BankLoadedCard(banks: bank),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openAddBank(context);
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
