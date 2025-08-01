import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:spendo/components/BackToHomeWrapper.dart';
import 'package:spendo/components/ConfirmAlertDialog.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/MonthPicker2.dart';
import 'package:spendo/components/cards/SubscriptionCard.dart';
import 'package:spendo/components/modals/ModalSubscription.dart';
import 'package:spendo/controllers/subscription_controller.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  bool _loading = false;
  DateTime _selectedMonth = DateTime.now();

  List filteredSubscriptions = [];
  double _filteredTotalValue = 0.0;

  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadSubscription());
  }

  Future<void> loadSubscription() async {
    if (_loading) return;

    setState(() => _loading = true);

    final controller = ref.read(subscriptionControllerProvider.notifier);
    final result = await controller.getSubscription();

    setState(() => _loading = false);

    if (result != null) {
      print('Erro: $result');
      return;
    }

    _applyFilter();
  }

  void _applyFilter() {
    final subscription = ref.read(subscriptionControllerProvider);

    filteredSubscriptions = subscription.where((sub) {
      try {
        if (sub.time == null || !sub.time.contains('até')) return false;

        final parts = sub.time.split('até');
        final startDate = formatter.parse(parts[0].trim());
        final endDate = formatter.parse(parts[1].trim());

        final selYear = _selectedMonth.year;
        final selMonth = _selectedMonth.month;

        final startYear = startDate.year;
        final startMonth = startDate.month;

        final endYear = endDate.year;
        final endMonth = endDate.month;

        bool afterOrEqualStart = (selYear > startYear) ||
            (selYear == startYear && selMonth >= startMonth);

        bool beforeOrEqualEnd =
            (selYear < endYear) || (selYear == endYear && selMonth < endMonth);

        return afterOrEqualStart && beforeOrEqualEnd;
      } catch (e) {
        return false;
      }
    }).toList();

    // Calcular total somente das assinaturas filtradas
    _filteredTotalValue = 0.0;
    for (var sub in filteredSubscriptions) {
      _filteredTotalValue += sub.value ?? 0.0;
    }

    setState(() {});
  }

  void onDelete(int id) async {
    final controller = ref.read(subscriptionControllerProvider.notifier);
    final response = await controller.deleteSubscription(id: id);

    if (response != null) {
      FloatingMessage(context, response, 'error', 2);
    } else {
      FloatingMessage(context, 'Assinatura deletada com sucesso', 'success', 2);
      await loadSubscription();
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
                    child: const ModalSubscription(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ).whenComplete(() async {
      await loadSubscription(); // Atualiza lista depois de fechar modal
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use o total calculado para as assinaturas filtradas
    final totalValue = _filteredTotalValue;

    return BackToHomeWrapper(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Assinaturas',
            style: TextStyle(color: AppTheme.whiteColor),
          ),
          leading: IconButton(
            icon: const Icon(
              Iconsax.arrow_left,
              color: AppTheme.whiteColor,
            ),
            onPressed: () => Navigator.of(context).pushReplacementNamed('/menu'),
          ),
           actions: [
          IconButton(
            icon: Icon(PhosphorIcons.question(PhosphorIconsStyle.regular), size: 28,),
            onPressed: () {
              FloatingMessage(context, "Arraste para esquerda para excluir", 'info', 6);
            },
          )
        ],
        ),
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                Customtext.formatMoeda(totalValue),
                style: const TextStyle(
                  color: AppTheme.whiteColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.dynamicBackgroundColor(context),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Monthpicker2(
                      selectedMonth: _selectedMonth,
                      onMonthSelected: (mes) {
                        setState(() {
                          _selectedMonth = mes ?? DateTime.now();
                          _applyFilter();
                        });
                      },
                      textColor: AppTheme.dynamicTextColor(context),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _loading
                          ? Center(
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: AppTheme.primaryColor,
                                size: 64,
                              ),
                            )
                          : filteredSubscriptions.isEmpty
                              ? const Center(
                                  child: Text(
                                    "Nenhuma assinatura encontrada",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: filteredSubscriptions.length,
                                  itemBuilder: (context, index) {
                                    final sub = filteredSubscriptions[index];
                                    return Dismissible(
                                      key: Key(sub.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      confirmDismiss: (direction) async {
                                        bool? confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (_) => ConfirmDeleteDialog(
                                            label: 'Assinatura',
                                            onConfirm: () {
                                              Navigator.of(context).pop(
                                                  true); // Retorna true para o Dismissible
                                            },
                                          ),
                                        );
                                        return confirmed ?? false;
                                      },
                                      onDismissed: (direction) {
                                        onDelete(sub.id!);
                                      },
                                      background: Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 14, right: 16, top: 2),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        alignment: Alignment.centerRight,
                                        child: const Icon(Iconsax.trash,
                                            color: Colors.white),
                                      ),
                                      child: SubscriptionCard(subscription: sub),
                                    );
                                  },
                                ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            )
          ],
        ),
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
      ),
    );
  }
}
