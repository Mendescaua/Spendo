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
        'color': const Color(0xFFFFCC29)
      },
      'itaú': {
        'image': 'assets/images/banks/itau.png',
        'color': const Color(0xFFFF6200)
      },
      'alelo': {
        'image': 'assets/images/banks/alelo.png',
        'color': const Color(0xFF00A859)
      },
      'banco bv': {
        'image': 'assets/images/banks/bancoBv.png',
        'color': const Color(0xFF660099)
      },
      'banco pan': {
        'image': 'assets/images/banks/bancoPan.png',
        'color': const Color(0xFF0094D6)
      },
      'btg': {
        'image': 'assets/images/banks/btg.png',
        'color': const Color(0xFF0033A0)
      },
      'c6 bank': {
        'image': 'assets/images/banks/c6.png',
        'color': const Color(0xFF000000)
      },
      'caixa': {
        'image': 'assets/images/banks/caixa.png',
        'color': const Color(0xFF005CA9)
      },
      'flash': {
        'image': 'assets/images/banks/flash.png',
        'color': const Color(0xFF2D9CDB)
      },
      'itaú ion': {
        'image': 'assets/images/banks/itauIon.png',
        'color': const Color(0xFFEC7000)
      },
      'itaú iti': {
        'image': 'assets/images/banks/itauIti.png',
        'color': const Color(0xFFEC7000)
      },
      'mastercard': {
        'image': 'assets/images/banks/mastercard.png',
        'color': const Color(0xFFEB001B)
      },
      'next': {
        'image': 'assets/images/banks/next.png',
        'color': const Color(0xFF00C5B5)
      },
      'nomad': {
        'image': 'assets/images/banks/nomad.png',
        'color': const Color(0xFF00D07E)
      },
      'paybank': {
        'image': 'assets/images/banks/paybank.png',
        'color': const Color(0xFF334AC0)
      },
      'pluxxe': {
        'image': 'assets/images/banks/pluxxe.png',
        'color': const Color(0xFF880ED4)
      },
      'porto seguro': {
        'image': 'assets/images/banks/portoBanco.png',
        'color': const Color(0xFF007DC6)
      },
      'rico': {
        'image': 'assets/images/banks/rico.png',
        'color': const Color(0xFFFF6600)
      },
      'safra': {
        'image': 'assets/images/banks/safra.png',
        'color': const Color(0xFF001B54)
      },
      'santander': {
        'image': 'assets/images/banks/santander.png',
        'color': const Color(0xFFEA1D25)
      },
      'sicoob': {
        'image': 'assets/images/banks/sicoob.png',
        'color': const Color(0xFF006633)
      },
      'sicred': {
        'image': 'assets/images/banks/sicred.png',
        'color': const Color(0xFF8DC63F)
      },
      'stone': {
        'image': 'assets/images/banks/stone.png',
        'color': const Color(0xFF00B140)
      },
      'ticket': {
        'image': 'assets/images/banks/ticket.png',
        'color': const Color(0xFFEE2737)
      },
      'vr': {
        'image': 'assets/images/banks/vr.png',
        'color': const Color(0xFF5BC500)
      },
      'visa': {
        'image': 'assets/images/banks/visa.png',
        'color': const Color(0xFF1A1F71)
      },
      'xp': {
        'image': 'assets/images/banks/xp.png',
        'color': const Color(0xFF000000)
      },
      'bradesco': {
        'image': 'assets/images/banks/bradesco.png',
        'color': const Color(0xFFCC092F)
      },
      'bmg': {
        'image': 'assets/images/banks/bmg.png',
        'color': const Color(0xFFFF6B00)
      },
      'hipercard': {
        'image': 'assets/images/banks/hipercard.png',
        'color': const Color(0xFFB41F3A)
      },
      'inter': {
        'image': 'assets/images/banks/inter.png',
        'color': const Color(0xFFFF6E00)
      },
      'mercado pago': {
        'image': 'assets/images/banks/mercadoPago.png',
        'color': const Color(0xFF2D9CDB)
      },
      'neon': {
        'image': 'assets/images/banks/neon.png',
        'color': const Color(0xFF00FFFF)
      },
      'paypal': {
        'image': 'assets/images/banks/paypal.png',
        'color': const Color(0xFF003087)
      },
      'picpay': {
        'image': 'assets/images/banks/picpay.png',
        'color': const Color(0xFF21C25E)
      },
      'will bank': {
        'image': 'assets/images/banks/willBank.png',
        'color': const Color(0xFFFFC300)
      },
    };

    final lowerName = name.toLowerCase();
    return data[lowerName] ??
        {
          'image': null,
        };
  }

  @override
  Widget build(BuildContext context) {
    final bankData = _getBankData(cards.name ?? '');
    final Color bgColor = bankData['color'] ?? Colors.grey;

    final String? bankImage = bankData['image'];

    return SizedBox(
      child: Container(
        width: 250,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor,
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
            // Linha do nome com logo do banco ao lado
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

                // Bandeiras antigas como estavam antes
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
