import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main_navigation_screen.dart'; // Importa a tua tela principal com abas

class AppColors {
  static const primary = Color(0xFF003CA5);
  static const background = Color(0xFFF3F4F6);
  static const border = Color(0xFFD1D5DB);
  static const hint = Color(0xFF9CA3AF);
  static const textSecondary = Color(0xFF6B7280);
  static const textPrimary = Color(0xFF111827);
}

class TelaLogin extends StatefulWidget {
  final bool criarConta;

  const TelaLogin({super.key, this.criarConta = false});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = true;
  bool _carregando = false;
  late bool _criarConta;

  @override
  void initState() {
    super.initState();
    _criarConta = widget.criarConta;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _carregando = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() => _carregando = false);

      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      // Validação do sistema temporário de login
      if (email == 'admin.com' && senha == 'admin123') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login efetuado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciais inválidas. Use admin.com e admin123'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPad = MediaQuery.sizeOf(context).width * (164 / 1080);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Utilização correta da imagem do logótipo a partir da pasta images/
                        Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Erro ao carregar o logo: $error');

                              return const Icon(
                                Icons.broken_image_outlined,
                                size: 64,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _criarConta
                                ? 'Criar Conta no Krono'
                                : 'Entrar no Krono',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.0,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _criarConta
                              ? 'Comece a organizar a sua rotina agora.'
                              : 'Continue a organizar o seu dia',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // Campo Email
                        _AppTextField(
                          hint: 'Email:',
                          icon: Icons.person_outline,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Insira o email' : null,
                        ),
                        const SizedBox(height: 13.33),

                        // Campo Senha
                        _AppTextField(
                          hint: 'Senha:',
                          icon: Icons.lock_outline,
                          controller: _senhaController,
                          obscureText: _mostrarSenha,
                          onToggleObscure: () =>
                              setState(() => _mostrarSenha = !_mostrarSenha),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Insira a senha' : null,
                        ),

                        if (!_criarConta) ...[
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Recuperação de senha acionada.',
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                'Esqueceu a senha?',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 28),

                        // Botão Principal
                        SizedBox(
                          height: 40.3,
                          child: ElevatedButton(
                            onPressed: _carregando ? null : _entrar,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                            ),
                            child: _carregando
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    _criarConta ? 'Criar Conta' : 'Entrar',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),

                        if (!_criarConta) ...[
                          const SizedBox(height: 24),
                          const Center(
                            child: Text(
                              'Ou entre rapidamente com:',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botão de login com Google
                          SizedBox(
                            height: 40.3,
                            child: OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Login com Google selecionado.',
                                    ),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: AppColors.border,
                                  width: 0.67,
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.g_mobiledata,
                                    size: 28,
                                    color: AppColors.primary,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Entrar com google',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 32),

                        // Rodapé de alternância
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _criarConta = !_criarConta;
                              });
                            },
                            child: Text(
                              _criarConta
                                  ? 'Já tem uma conta? Entrar'
                                  : 'Não tem uma conta? Criar Conta',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.onToggleObscure,
    this.keyboardType,
    this.validator,
  });

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39.67,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9.67),
        border: Border.all(color: AppColors.border, width: 0.67),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.hint),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              cursorColor: AppColors.primary,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              decoration:
                  const InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                  ).copyWith(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.hint,
                    ),
                  ),
            ),
          ),
          if (onToggleObscure != null)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onToggleObscure,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Icon(
                  obscureText
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 16,
                  color: AppColors.hint,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
