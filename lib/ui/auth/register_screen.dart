import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spendo/controllers/auth_controller.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/buttons/StyleButton.dart';
import 'package:spendo/utils/theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  bool isObscure = true;
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void register() async {
    if (isLoading) return; // Impede múltiplos cliques

    setState(() {
      isLoading = true;
    });

    final result = await _authController.register(
      email: emailController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      name: nameController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (result == null) {
      FloatingMessage(context, "Cadastro realizado com sucesso", "success", 2);
      Navigator.of(context).pushReplacementNamed('/onboarding');
    } else {
      FloatingMessage(context, result.toString(), "error", 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: IconButton(
                          icon: const Icon(Iconsax.arrow_left),
                          color: AppTheme.whiteColor,
                          iconSize: 26,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const Text(
                        'Cadastro',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Nome',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.user),
                      hintText: 'Seu nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF4678c0),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: emailController,
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
                  const Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.security_safe),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: isObscure
                              ? const Icon(Iconsax.eye_slash)
                              : const Icon(Iconsax.eye)),
                      hintText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF4678c0),
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Confirmar senha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Iconsax.security_safe),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: isObscure
                              ? const Icon(Iconsax.eye_slash)
                              : const Icon(Iconsax.eye)),
                      hintText: 'Confirmar senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF4678c0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  StyleButton(
                    isLoading: isLoading,
                    text: 'Cadastrar',
                    onClick: isLoading ? null : register,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Já possui uma conta?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
