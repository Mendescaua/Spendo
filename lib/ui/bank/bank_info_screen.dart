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
    final info = await controller.getBankInfo(
        bankName: widget.banks.name, date: DateTime.now());

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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.banks.name,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topo com saldo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
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
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Conteúdo com detalhes
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppTheme.dynamicBackgroundColor(context),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
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
                      : SingleChildScrollView(
                          child: Column(
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
                              InfoTile(
                                icon: Iconsax.bank,
                                label: 'Instituição bancária',
                                content: widget.banks.name,
                              ),
                              InfoTile(
                                icon: Iconsax.card,
                                label: 'Tipo da conta',
                                content: widget.banks.type,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TransactionBankScreen(
                                      bankName: widget.banks.name,
                                      type: 'd',
                                    ),
                                  ),
                                ),
                                child: InfoTile(
                                  icon: Iconsax.money,
                                  label: 'Despesas',
                                  content: '${stats['despesa_count']}',
                                  iconColor:
                                      AppTheme.dynamicDespesaColor(context),
                                  contentColor:
                                      AppTheme.dynamicDespesaColor(context),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TransactionBankScreen(
                                      bankName: widget.banks.name,
                                      type: 'r',
                                    ),
                                  ),
                                ),
                                child: InfoTile(
                                  icon: Iconsax.money,
                                  label: 'Receitas',
                                  content: '${stats['receita_count']}',
                                  iconColor:
                                      AppTheme.dynamicReceitaColor(context),
                                  contentColor:
                                      AppTheme.dynamicReceitaColor(context),
                                ),
                              ),
                              InfoTile(
                                icon: Iconsax.repeat,
                                label: 'Total de transações',
                                content: '${stats['transaction_count']}',
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String content;
  final Color? iconColor;
  final Color? contentColor;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.content,
    this.iconColor,
    this.contentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        leading: Icon(icon, size: 24, color: iconColor),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: contentColor ?? AppTheme.dynamicTextColor(context),
            ),
          ),
        ),
      ),
    );
  }
}
