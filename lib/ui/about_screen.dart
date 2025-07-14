import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre o Spendo"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Iconsax.arrow_left,
            color: AppTheme.whiteColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              SvgPicture.asset(
                'assets/images/IconSpendo.svg',
                width: 50,
                height: 50,
              ),
              const SizedBox(height: 12),
              Text(
                "Spendo",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                "Controle suas finanças de forma simples e eficiente.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(),
          ListTile(
            leading: const Icon(Iconsax.code),
            title: const Text("Versão"),
            subtitle: const Text("1.0.0"),
          ),
          ListTile(
            leading: const Icon(Iconsax.user),
            title: const Text("Desenvolvido por"),
            subtitle: const Text("Cauã Mendes"),
          ),
          ListTile(
            leading: const Icon(Iconsax.message_question),
            title: const Text("Contato"),
            subtitle: const Text("cauamende1703@gmail.com"),
            onTap: () {
              // Abrir link com url_launcher
              launchUrl(Uri.parse('mailto:cauamende1703@gmail.com'));
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.global),
            title: const Text("Website"),
            subtitle: const Text("www.linkedin.com/in/cauãmendes"),
            onTap: () {
              // Abrir link com url_launcher
              launchUrl(Uri.parse('https://www.linkedin.com/in/cau%C3%A3mendes'));
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            "Este aplicativo foi desenvolvido com o objetivo de ajudar pessoas a terem controle total sobre seus gastos, receitas e economias. Todos os dados são armazenados com segurança e privacidade.",
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
