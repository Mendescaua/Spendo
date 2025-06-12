import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/controllers/auth_controller.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
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
              title: const Text('Perfil'),
            ),
            body: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    // Foto de perfil circular
                    Center(
                      child: const CircleAvatar(
                        radius: 70,
                        backgroundImage: NetworkImage(
                            'https://avatars.githubusercontent.com/u/104581895?v=4'),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'Nome',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.user),
                        hintText: 'Nome',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4678c0),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Senha',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Iconsax.lock),
                        hintText: 'Senha',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: Color(0xFF4678c0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {logout();},
              child: const Icon(Iconsax.logout),
            ),
          );
  }
}
