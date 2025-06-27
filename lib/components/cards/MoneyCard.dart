import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:spendo/models/money_card_model.dart';

class MoneyCard extends StatelessWidget {
  MoneyCard({
    super.key,
    required this.cards,
  });

  final MoneyCardModel cards;

  Map<String, dynamic> _getBankData(String name) {
    final data = {
      'nubank': {
        'image': 'assets/images/banks/nuBank.png',
        'color': const Color(0xFF820AD1)
      },
      'banco do brasil': {
        'image': 'assets/images/banks/bancobrasil.png',
        'color': const Color(0xFFFDE100)
      },
      'itaú': {
        'image': 'assets/images/banks/itau.png',
        'color': const Color(0xFFFF6200)
      },
      'alelo': {
        'image': 'assets/images/banks/alelo.png',
        'color': const Color(0xFFC7D540)
      },
      'banco bv': {
        'image': 'assets/images/banks/bancoBv.png',
        'color': const Color(0xFF223AD2)
      },
      'banco pan': {
        'image': 'assets/images/banks/bancoPan.png',
        'color': const Color(0xFF00C5FF)
      },
      'btg': {
        'image': 'assets/images/banks/btg.png',
        'color': const Color(0xFF001E61)
      },
      'c6 bank': {
        'image': 'assets/images/banks/c6.png',
        'color': const Color(0xFF000000)
      },
      'caixa': {
        'image': 'assets/images/banks/caixa.png',
        'color': const Color(0xFF0070AF)
      },
      'flash': {
        'image': 'assets/images/banks/flash.png',
        'color': const Color(0xFFFE2B8F)
      },
      'itaú ion': {
        'image': 'assets/images/banks/itauIon.png',
        'color': const Color(0xFF133034)
      },
      'itaú iti': {
        'image': 'assets/images/banks/itauItiWhite.png',
        'gradient': const LinearGradient(
          colors: [
            Color(0xFFFF4CA1), // rosa
            Color(0xFFFF9068), // laranja claro
            Color(0xFFFF784B), // laranja escuro
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      'mastercard': {
        'image': 'assets/images/banks/mastercard.png',
        'color': const Color(0xFF231F20)
      },
      'next': {
        'image': 'assets/images/banks/next.png',
        'color': const Color(0xFF01FF5F)
      },
      'nomad': {
        'image': 'assets/images/banks/nomad.png',
        'color': const Color(0xFFFFCE00)
      },
      'paybank': {
        'image': 'assets/images/banks/paybank.png',
        'color': const Color(0xFF1BB99A)
      },
      'pluxxe': {
        'image': 'assets/images/banks/pluxxe.png',
        'color': const Color(0xFF00EB5E)
      },
      'porto seguro': {
        'image': 'assets/images/banks/portoBanco.png',
        'color': const Color(0xFF2B56C0)
      },
      'rico': {
        'image': 'assets/images/banks/rico.png',
        'color': const Color(0xFF010044)
      },
      'safra': {
        'image': 'assets/images/banks/safra.png',
        'color': const Color(0xFF1E2044)
      },
      'santander': {
        'image': 'assets/images/banks/santander.png',
        'color': const Color(0xFFEA1D25)
      },
      'sicoob': {
        'image': 'assets/images/banks/sicoob.png',
        'color': const Color(0xFF003B43)
      },
      'sicred': {
        'image': 'assets/images/banks/sicred.png',
        'color': const Color(0xFF3DAE2B)
      },
      'stone': {
        'image': 'assets/images/banks/stone.png',
        'color': const Color(0xFF00A868)
      },
      'ticket': {
        'image': 'assets/images/banks/ticket.png',
        'color': const Color(0xFFD52B1E)
      },
      'vr': {
        'image': 'assets/images/banks/vr.png',
        'color': const Color(0xFF02D72F)
      },
      'visa': {
        'image': 'assets/images/banks/visa.png',
        'color': const Color(0xFF172B85)
      },
      'xp': {
        'image': 'assets/images/banks/xp.png',
        'color': const Color(0xFF000000)
      },
      'bradesco': {
        'image': 'assets/images/banks/bradescoWhite.png',
        'gradient': const LinearGradient(
          colors: [
            Color(0xFFD90429), // vermelho vibrante
            Color(0xFF9D0164), // rosa/roxo escuro
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      'bmg': {
        'image': 'assets/images/banks/bmg.png',
        'color': const Color(0xFFFA6300)
      },
      'hipercard': {
        'image': 'assets/images/banks/hipercard.png',
        'color': const Color(0xFFB3131B)
      },
      'inter': {
        'image': 'assets/images/banks/inter.png',
        'color': const Color(0xFFEA7100)
      },
      'mercado pago': {
        'image': 'assets/images/banks/mercadoPago.png',
        'color': const Color(0xFF00BCFF)
      },
      'neon': {
        'image': 'assets/images/banks/neonWhite.png',
        'gradient': const LinearGradient(
          colors: [
            Color(0xFF00C6FB), // azul neon
            Color(0xFF00E5E5), // turquesa claro
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      },
      'paypal': {
        'image': 'assets/images/banks/paypal.png',
        'color': const Color(0xFF003087)
      },
      'picpay': {
        'image': 'assets/images/banks/picpay.png',
        'color': const Color(0xFF26A65E)
      },
      'will bank': {
        'image': 'assets/images/banks/willBank.png',
        'color': const Color(0xFFFFD900)
      },
    };

    final lowerName = name.toLowerCase();
    return data[lowerName] ?? {'image': null};
  }

  @override
  Widget build(BuildContext context) {
    final bankData = _getBankData(cards.name ?? '');
    final Gradient? bgGradient = bankData['gradient'];
    final Color? bgColor = bankData['color'];
    final String? bankImage = bankData['image'];

    return SizedBox(
      child: Container(
        width: 250,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: bgGradient,
          color: bgGradient == null ? (bgColor ?? Colors.grey) : null,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            bankImage != null
                ? Image.asset(
                    bankImage,
                    height: 35,
                    fit: BoxFit.contain,
                  )
                : const Icon(
                    Iconsax.card,
                    color: Colors.white,
                    size: 30,
                  ),
            Text(
              "**** **** **** ${cards.number.round()}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Validade ${DateFormat('MM/yy').format(cards.validity!)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 8),
                if (cards.flag.toLowerCase() == 'visa')
                  Image.asset('assets/images/VisaLogo.png', height: 18)
                else if (cards.flag.toLowerCase() == 'mastercard')
                  Image.asset('assets/images/MastercardLogo.png', height: 32)
                else if (cards.flag.toLowerCase() == 'elo')
                  Image.asset('assets/images/EloLogo.png', height: 24)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
