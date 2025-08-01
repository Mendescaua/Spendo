import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/controllers/auth_controller.dart';
import 'package:spendo/utils/theme.dart';

class ModalChangePassword extends StatefulWidget {
  const ModalChangePassword({Key? key}) : super(key: key);

  @override
  State<ModalChangePassword> createState() => _ModalChangePasswordState();
}

class _ModalChangePasswordState extends State<ModalChangePassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthController _authController = AuthController();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    final newPassword = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // verifica se informou a nova senha e a confirmação
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      FloatingMessage(context, 'Preencha todos os campos.', 'error', 2);
      return;
    }

    if (newPassword != confirmPassword) {
      FloatingMessage(context, 'As senhas não coincidem.', 'error', 2);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authController.changePassword(newPassword);

    setState(() => _isLoading = false);

    if (result == null) {
      Navigator.of(context).pop(); // fecha o bottom sheet
      FloatingMessage(context, 'Senha alterada com sucesso!', "success", 2);
    } else {
      FloatingMessage(context, 'Erro ao alterar senha: $result', "error", 2);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
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
        height: size.height * 0.50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Alterar Senha',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nova senha',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Digite a nova senha',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppTheme.dynamicTextFieldColor(context),
                  prefixIcon: Icon(
                    Iconsax.lock,
                    size: 24,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite a nova senha';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Confirme a senha',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Confirme a nova senha',
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor: AppTheme.dynamicTextFieldColor(context),
                  prefixIcon: Icon(
                    Iconsax.lock,
                    size: 24,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirme a senha';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            StyleButton(
              text: _isLoading ? 'Salvando...' : 'Salvar',
              onClick: _isLoading ? null : _changePassword,
            ),
          ],
        ),
      ),
    );
  }
}
