import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/controllers/auth_controller.dart';

class ConfiguracoesScreen extends StatefulWidget {
  const ConfiguracoesScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  final AuthController _authController = AuthController();

 void logout() async {
  await _authController.signOut();

  if (!mounted) return; // <- isso evita o erro

  Navigator.of(context).pop();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Configurações',
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Perfil Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/user.jpg'), // sua imagem
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Cauã Mendes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('caua@email.com', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit, color: Colors.grey),
                  onPressed: () {
                    // ação de editar
                  },
                )
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Preferências Card
          _buildCard(
            title: 'Gerenciar',
            children: [
              _buildTile(Iconsax.bank, 'Contas', () {}),
              _buildTile(Iconsax.save_2, 'Categorias', () {}),
            ],
          ),

          const SizedBox(height: 24),

          // Segurança
          _buildCard(
            title: 'Segurança',
            children: [
              _buildTile(Iconsax.security_safe, 'Alterar senha', () {}),
              _buildTile(Iconsax.finger_cricle, 'Autenticação biométrica', () {}),
            ],
          ),

          const SizedBox(height: 24),

          // Outros
          _buildCard(
            title: 'Outros',
            children: [
              _buildTile(Iconsax.info_circle, 'Sobre o app', () {}),
              _buildTile(Iconsax.logout, 'Sair', () {
                logout();
              }, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(title,
          style: TextStyle(color: color ?? Colors.black, fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildSwitchTile(
      IconData icon, String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      value: value,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }
}
