import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme_controller.dart';
import 'login_screen.dart';

// ============================================================
// CONTROLADOR GLOBAL DA FOTO DE PERFIL
// ============================================================
final ValueNotifier<String?> globalUserPhoto = ValueNotifier<String?>(
  FirebaseAuth.instance.currentUser?.photoURL,
);

class AppColors {
  static const primary = Color(0xFF003CA5);

  static const backgroundLight = Color(0xFFF3F4F6);
  static const backgroundDark = Color(0xFF121212);

  static const surfaceLight = Colors.white;
  static const surfaceDark = Color(0xFF1E1E1E);

  static const borderLight = Color(0xFFD1D5DB);
  static const borderDark = Color(0xFF2C2C2C);

  static const textSecondaryLight = Color(0xFF6B7280);
  static const textSecondaryDark = Color(0xFFA0A0A0);

  static const textPrimaryLight = Color(0xFF111827);
  static const textPrimaryDark = Color(0xFFF9FAFB);
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    themeController.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  // Função universal para carregar e atualizar a foto de perfil (Compatível com Web e Mobile)
  Future<void> _alterarFotoPerfil() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile == null) return;

    setState(() => _isUploading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // 1. Referência para o Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      // 2. Ler os bytes do ficheiro (Funciona tanto em Mobile como na Web sem erros de IO)
      final bytes = await pickedFile.readAsBytes();

      // 3. Fazer o upload utilizando os bytes
      await storageRef.putData(
        bytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      // 4. Obter a URL pública do Storage
      final downloadUrl = await storageRef.getDownloadURL();

      // 5. Atualizar no Firebase Auth
      await user.updatePhotoURL(downloadUrl);

      // 6. Atualizar o estado global instantaneamente em todo o app
      globalUserPhoto.value = downloadUrl;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto de perfil atualizada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _sairDaConta(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TelaLogin(criarConta: false)),
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair da conta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;

    final bgColor = isDark
        ? AppColors.backgroundDark
        : AppColors.backgroundLight;

    final surfaceColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;

    final textColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.textPrimaryLight;

    final secondaryTextColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondaryLight;

    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(
          'Meu Perfil',
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: surfaceColor,
        elevation: 0.5,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder<String?>(
              valueListenable: globalUserPhoto,
              builder: (context, photoUrl, child) {
                return CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                      ? NetworkImage(photoUrl) as ImageProvider
                      : null,
                  child: photoUrl == null || photoUrl.isEmpty
                      ? const Icon(Icons.person, color: AppColors.primary)
                      : null,
                );
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    ValueListenableBuilder<String?>(
                      valueListenable: globalUserPhoto,
                      builder: (context, photoUrl, child) {
                        return CircleAvatar(
                          radius: 45,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          backgroundImage:
                              photoUrl != null && photoUrl.isNotEmpty
                              ? NetworkImage(photoUrl) as ImageProvider
                              : const NetworkImage(
                                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                                ),
                        );
                      },
                    ),
                    if (_isUploading)
                      const Positioned.fill(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: InkWell(
                        onTap: _isUploading ? null : _alterarFotoPerfil,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  FirebaseAuth.instance.currentUser?.displayName ??
                      'Lucca Scovini',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Usuário Premium',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Configurações Pessoais',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: secondaryTextColor,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  'Conta e Segurança',
                  Icons.settings_outlined,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ContaSegurancaScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Notificações',
                  Icons.notifications_outlined,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificacoesScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Aparência & Tema',
                  Icons.palette_outlined,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AparenciaScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Idioma do Sistema',
                  Icons.language_outlined,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const IdiomaScreen()),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Privacidade',
                  Icons.lock_outline,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PrivacidadeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Sobre o Krono',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: secondaryTextColor,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  'Avaliar na App Store',
                  Icons.star_border_rounded,
                  textColor,
                  secondaryTextColor,
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Redirecionando para a loja...'),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Central de Ajuda',
                  Icons.help_outline_rounded,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CentralAjudaScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Termos de Uso',
                  Icons.description_outlined,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TermosUsoScreen(),
                      ),
                    );
                  },
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _buildMenuItem(
                  context,
                  'Política de Privacidade',
                  Icons.privacy_tip_outlined,
                  textColor,
                  secondaryTextColor,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PoliticaPrivacidadeScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () => _sairDaConta(context),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: const StadiumBorder(),
              ),
              child: const Text(
                'Sair da Conta',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Color textColor,
    Color secondaryColor,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, size: 20, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 12, color: secondaryColor),
      onTap: onTap,
    );
  }
}

// ============================================================
// OUTRAS TELAS DE SUPORTE
// ============================================================

class AparenciaScreen extends StatefulWidget {
  const AparenciaScreen({super.key});

  @override
  State<AparenciaScreen> createState() => _AparenciaScreenState();
}

class _AparenciaScreenState extends State<AparenciaScreen> {
  @override
  void initState() {
    super.initState();
    themeController.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Aparência',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 0.5,
              ),
            ),
            child: SwitchListTile(
              title: Text(
                'Modo Escuro (Dark Mode)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight,
                ),
              ),
              subtitle: Text(
                'Ativar o tema escuro em toda a aplicação',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              value: themeController.isDarkMode,
              activeColor: AppColors.primary,
              onChanged: (value) {
                themeController.toggleTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IdiomaScreen extends StatelessWidget {
  const IdiomaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Idioma',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          RadioListTile<String>(
            title: Text(
              'Português',
              style: TextStyle(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            value: 'pt',
            groupValue: 'pt',
            activeColor: AppColors.primary,
            onChanged: (v) {},
          ),
        ],
      ),
    );
  }
}

class ContaSegurancaScreen extends StatelessWidget {
  const ContaSegurancaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Conta e Segurança',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: const []),
    );
  }
}

class NotificacoesScreen extends StatefulWidget {
  const NotificacoesScreen({super.key});
  @override
  State<NotificacoesScreen> createState() => _NotificacoesScreenState();
}

class _NotificacoesScreenState extends State<NotificacoesScreen> {
  bool _push = true;
  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Notificações',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: const []),
    );
  }
}

class PrivacidadeScreen extends StatelessWidget {
  const PrivacidadeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Privacidade',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Dados encriptados.'),
      ),
    );
  }
}

class CentralAjudaScreen extends StatelessWidget {
  const CentralAjudaScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Central de Ajuda',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: const SizedBox(),
    );
  }
}

class TermosUsoScreen extends StatelessWidget {
  const TermosUsoScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Termos de Uso',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: const SizedBox(),
    );
  }
}

class PoliticaPrivacidadeScreen extends StatelessWidget {
  const PoliticaPrivacidadeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final isDark = themeController.isDarkMode;
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Política de Privacidade',
          style: TextStyle(
            color: isDark
                ? AppColors.textPrimaryDark
                : AppColors.textPrimaryLight,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight,
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: const SizedBox(),
    );
  }
}
