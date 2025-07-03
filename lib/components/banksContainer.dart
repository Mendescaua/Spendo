import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Bankscontainer extends StatelessWidget {
  final String name;

  const Bankscontainer({Key? key, required this.name}) : super(key: key);

  String? _getImagePath(String name) {
    switch (name.toLowerCase()) {
      case 'nubank':
        return 'assets/images/banks/nuBank.png';
      case 'banco do brasil':
        return 'assets/images/banks/bancobrasil.png';
      case 'itaú':
        return 'assets/images/banks/itau.png';
      case 'alelo':
        return 'assets/images/banks/alelo.png';
      case 'banco bv':
        return 'assets/images/banks/bancoBv.png';
      case 'banco pan':
        return 'assets/images/banks/bancoPan.png';
      case 'btg':
        return 'assets/images/banks/btg.png';
      case 'c6 bank':
        return 'assets/images/banks/c6.png';
      case 'caixa':
        return 'assets/images/banks/caixa.png';
      case 'flash':
        return 'assets/images/banks/flash.png';
      case 'itaú ion':
        return 'assets/images/banks/itauIon.png';
      case 'itaú iti':
        return 'assets/images/banks/itauIti.png';
      case 'mastercard':
        return 'assets/images/banks/mastercard.png';
      case 'next':
        return 'assets/images/banks/next.png';
      case 'nomad':
        return 'assets/images/banks/nomad.png';
      case 'paybank':
        return 'assets/images/banks/paybank.png';
      case 'pluxxe':
        return 'assets/images/banks/pluxxe.png';
      case 'porto seguro':
        return 'assets/images/banks/portoBanco.png';
      case 'rico':
        return 'assets/images/banks/rico.png';
      case 'safra':
        return 'assets/images/banks/safra.png';
      case 'santander':
        return 'assets/images/banks/santander.png';
      case 'sicoob':
        return 'assets/images/banks/sicoob.png';
      case 'sicred':
        return 'assets/images/banks/sicred.png';
      case 'stone':
        return 'assets/images/banks/stone.png';
      case 'ticket':
        return 'assets/images/banks/ticket.png';
      case 'vr':
        return 'assets/images/banks/vr.png';
      case 'visa':
        return 'assets/images/banks/visa.png';
      case 'xp':
        return 'assets/images/banks/xp.png';
      case 'bradesco':
        return 'assets/images/banks/bradesco.png';
      case 'bmg':
        return 'assets/images/banks/bmg.png';
      case 'hipercard':
        return 'assets/images/banks/hipercard.png';
      case 'inter':
        return 'assets/images/banks/inter.png';
      case 'mercado pago':
        return 'assets/images/banks/mercadoPago.png';
      case 'neon':
        return 'assets/images/banks/neon.png';
      case 'paypal':
        return 'assets/images/banks/paypal.png';
      case 'picpay':
        return 'assets/images/banks/picpay.png';
      case 'will bank':
        return 'assets/images/banks/willBank.png';
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imagePath = _getImagePath(name);

    return Container(
  width: 42,
  height: 42,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    color: const Color(0xFFE5E7EB),
    image: imagePath != null && imagePath.isNotEmpty
        ? DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.contain,
          )
        : null,
  ),
  child: imagePath == null || imagePath.isEmpty
      ? const Icon(Iconsax.wallet, color: Color(0xFF4678C0))
      : null,
);

  }
}
