import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/CircleImage.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/user_controller.dart';
import 'package:spendo/models/users_model.dart';
import 'package:spendo/utils/theme.dart';

class ModalEditPerfil extends ConsumerStatefulWidget {
  const ModalEditPerfil({super.key});

  @override
  ConsumerState<ModalEditPerfil> createState() => _ModalEditPerfilState();
}

class _ModalEditPerfilState extends ConsumerState<ModalEditPerfil> {
  final TextEditingController _usercontroller = TextEditingController();
  String? picture;
  
    @override
  void initState() {
    super.initState();

    // Aguarda o build e depois preenche os dados do usuário
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(userControllerProvider).firstOrNull;
      if (user != null) {
        _usercontroller.text = user.name;
        picture = user.picture;
      }
    });
  }

  void onUpdate() {
    final controller = ref.read(userControllerProvider.notifier);
    controller.updateUser(
      name: _usercontroller.text,
      picture: picture,
    );
    FloatingMessage(context, 'Valor adicionado com sucesso', 'success', 2);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _usercontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;    
    final users = ref.watch(userControllerProvider).firstOrNull;
   
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.dynamicModalColor(context),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          width: double.infinity,
          height: size.height * 0.68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: const Text(
                  'Dados do perfil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                  child: CircleImage(
                initialBase64:
                    users?.picture ?? null, // ou passe base64 inicial
                onImageSelected: (base64) {
                  picture = base64;
                },
              )),
              SizedBox(height: 16),
              const Text(
                'Usuário',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller: _usercontroller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.user),
                  hintText: 'Usuário',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF4678c0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              const Text(
                'Email',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                readOnly: true,
                controller: TextEditingController(text: users?.email ?? ''),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.sms),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFF4678c0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              StyleButton(text: 'Salvar', onClick: () {onUpdate();}),
            ],
          ),
        ),
      ),
    );
  }
}
