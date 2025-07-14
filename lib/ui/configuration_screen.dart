import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendo/components/FloatingMessage.dart';
import 'package:spendo/components/modals/ModalChangePassword.dart';
import 'package:spendo/components/modals/ModalEditPerfil.dart';
import 'package:spendo/components/modals/ModalTheme.dart';
import 'package:spendo/controllers/auth_controller.dart';
import 'package:spendo/controllers/user_controller.dart';
import 'package:spendo/utils/base64.dart';
import 'package:spendo/utils/customText.dart';
import 'package:spendo/utils/theme.dart';

class ConfiguracoesScreen extends ConsumerStatefulWidget {
  const ConfiguracoesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConfiguracoesScreen> createState() =>
      _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends ConsumerState<ConfiguracoesScreen> {
  final AuthController _authController = AuthController();
  bool autenticacaoAtivada = false;

  @override
  void initState() {
    super.initState();
    _carregarPreferenciaAutenticacao();
  }

  void _carregarPreferenciaAutenticacao() async {
    final prefs = await SharedPreferences.getInstance();
    final ativada = prefs.getBool('autenticacao_ativada') ?? false;
    setState(() {
      autenticacaoAtivada = ativada;
    });
  }

  Future<void> _salvarPreferenciaAutenticacao(bool ativada) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autenticacao_ativada', ativada);
  }

  void logout() async {
    ref
        .read(userControllerProvider.notifier)
        .clear(); // Limpa o estado manualmente ANTES de desmontar o widget
    await _authController.signOut();
    if (!mounted) return;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(userControllerProvider).firstOrNull;
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
              color: AppTheme.dynamicCardColor(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage:
                      users?.picture != null && users!.picture!.isNotEmpty
                          ? base64ToImage(users.picture!)
                          : null,
                  child: users?.picture == null || users!.picture!.isEmpty
                      ? Text(
                          (users?.name.isNotEmpty ?? false)
                              ? users!.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Customtext.capitalizeFirstLetter(
                            users?.name ?? 'Sem nome'),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        users?.email ?? 'Sem email',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Iconsax.edit, color: Colors.grey),
                  onPressed: () {
                    _openEditPerfilModal(context);
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
              _buildTile(Iconsax.bank, 'Contas', () {
                Navigator.of(context).pushNamed('/bank');
              }),
              _buildTile(
                Iconsax.tag,
                'Categorias',
                () {
                  Navigator.of(context).pushNamed('/category');
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Segurança
          _buildCard(
            title: 'Segurança',
            children: [
              _buildTile(Iconsax.security_safe, 'Alterar senha', () {
                _openChangePasswordModal(context);
              }),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Exigir autenticação ao abrir o app',
                  style: TextStyle(
                    color: AppTheme.dynamicTextColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                secondary: Icon(Iconsax.security_user,
                    color: AppTheme.dynamicTextColor(context)),
                value: autenticacaoAtivada,
                onChanged: (value) async {
                  final auth = LocalAuthentication();
                  bool suportado = await auth.isDeviceSupported();
                  if (!suportado) {
                    FloatingMessage(context, 'Seu dispositivo não suporta autenticação.', 'info', 2);
                    return;
                  }

                  // Autentica com biometria ou método do sistema
                  bool autenticado = await auth.authenticate(
                    localizedReason: value
                        ? 'Autentique-se para ativar a proteção de entrada'
                        : 'Autentique-se para desativar a proteção',
                    options: const AuthenticationOptions(
                      biometricOnly:
                          false, // <- permite biometria OU senha/padrão/PIN
                      stickyAuth: true,
                    ),
                  );

                  if (autenticado) {
                    await _salvarPreferenciaAutenticacao(value);
                    setState(() {
                      autenticacaoAtivada = value;
                    });
                  }
                },
              )
            ],
          ),

          const SizedBox(height: 24),

          // Outros
          _buildCard(
            title: 'Outros',
            children: [
              _buildTile(PhosphorIcons.sun(PhosphorIconsStyle.regular), 'Tema',
                  () {
                showThemeSelectionModal(context, ref);
              }),
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
        color: AppTheme.dynamicCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.dynamicTextColor(context))),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.dynamicTextColor(context)),
      title: Text(title,
          style: TextStyle(
              color: color ?? AppTheme.dynamicTextColor(context),
              fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  void _openEditPerfilModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      clipBehavior: Clip.antiAlias,
                      child: ModalEditPerfil()),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openChangePasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => ScaffoldMessenger(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: ModalChangePassword(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
