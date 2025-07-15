import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spendo/controllers/bank_controller.dart';
import 'package:spendo/models/bank_model.dart';
import 'package:spendo/ui/bank/transaction_bank_screen.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class BankInfoScreen extends ConsumerStatefulWidget {
  final BanksModel banks;
  const BankInfoScreen({
    super.key,
    required this.banks,
  });

  @override
  ConsumerState<BankInfoScreen> createState() => _BankInfoScreenState();
}

class _BankInfoScreenState extends ConsumerState<BankInfoScreen> {
  bool _loading = false;
  Map<String, dynamic>? bankStats;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await loadTransactions();
    });
  }

  Future<void> loadTransactions() async {
    if (!mounted) return;
    setState(() => _loading = true);

    final controller = ref.read(bankControllerProvider.notifier);
    final info = await controller.getBankInfo(bankName: widget.banks.name);

    if (!mounted) return;
    setState(() => _loading = false);

    if (info == null) {
      setState(() {
        bankStats = {
          'transaction_count': 0,
          'despesa_count': 0,
          'receita_count': 0,
          'total_value': 0.0,
        };
      });
    } else {
      setState(() {
        bankStats = info;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = bankStats;

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      appBar: AppBar(
        title: Text(widget.banks.name),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topo com saldo — mostra valor ou placeholder
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  stats != null
                      ? Customtext.formatMoeda(stats['total_value'])
                      : '--',
                  style: const TextStyle(
                    color: AppTheme.whiteColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Container branco com detalhes ou loading
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: _loading
                  ? Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppTheme.primaryColor, size: 60),
                    )
                  : stats == null
                      ? Center(
                          child: Text(
                            'Nenhum dado disponível',
                            style: TextStyle(
                              color: AppTheme.dynamicTextColor(context),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Detalhes da Conta',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.dynamicTextColor(context),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _infoItem(
                              icon: Iconsax.bank,
                              iconColor: AppTheme.primaryColor,
                              label: 'Instituição bancária',
                              value: widget.banks.name,
                            ),
                            _divider(),
                            _infoItem(
                              icon: Iconsax.card,
                              iconColor: AppTheme.primaryColor,
                              label: 'Tipo da conta',
                              value: widget.banks.type,
                            ),
                            _divider(),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TransactionBankScreen(
                                  bankName: widget.banks.name,
                                  type: 'd',
                                ),
                              )),
                              child: _infoItem(
                                icon: Iconsax.money,
                                iconColor:
                                    AppTheme.dynamicDespesaColor(context),
                                label: 'Despesas',
                                value: '${stats['despesa_count']}',
                                valueColor:
                                    AppTheme.dynamicDespesaColor(context),
                              ),
                            ),
                            _divider(),
                            GestureDetector(
                              onTap: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TransactionBankScreen(
                                  bankName: widget.banks.name,
                                  type: 'r',
                                ),
                              )),
                              child: _infoItem(
                                icon: Iconsax.money,
                                iconColor:
                                    AppTheme.dynamicReceitaColor(context),
                                label: 'Receitas',
                                value: '${stats['receita_count']}',
                                valueColor:
                                    AppTheme.dynamicReceitaColor(context),
                              ),
                            ),
                            _divider(),
                            _infoItem(
                              icon: Iconsax.repeat,
                              iconColor: AppTheme.primaryColor,
                              label: 'Total de transações',
                              value: '${stats['transaction_count']}',
                            ),
                          ],
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.dynamicTextColor(context).withOpacity(0.8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppTheme.dynamicTextColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      color: Colors.grey.withOpacity(0.3),
      thickness: 1,
      height: 0,
    );
  }
}
