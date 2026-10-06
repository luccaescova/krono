import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importação do Firebase Auth
import 'main_navigation_screen.dart';

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

  // ============================================================
  // CAMPOS
  // ============================================================

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  // ============================================================
  // CONTROLES
  // ============================================================

  bool _mostrarSenha = false;
  bool _mostrarConfirmarSenha = false;
  bool _carregando = false;
  bool _aceitouTermos = false;

  late bool _criarConta;

  @override
  void initState() {
    super.initState();
    _criarConta = widget.criarConta;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _dataNascimentoController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();

    super.dispose();
  }

  // ============================================================
  // LOGIN (FIREBASE)
  // ============================================================

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _carregando = true;
    });

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      // Autenticação real com o Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!mounted) return;

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
    } on FirebaseAuthException catch (e) {
      String mensagemErro = 'Erro ao efetuar login.';
      if (e.code == 'user-not-found') {
        mensagemErro = 'Utilizador não encontrado.';
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        mensagemErro = 'E-mail ou senha incorretos.';
      } else if (e.code == 'invalid-email') {
        mensagemErro = 'O formato do e-mail é inválido.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  // ============================================================
  // CRIAR CONTA (FIREBASE)
  // ============================================================

  Future<void> _criarNovaConta() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_aceitouTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Você precisa concordar com os Termos de Uso e Política de Privacidade.',
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _carregando = true;
    });

    try {
      final email = _emailController.text.trim();
      final senha = _senhaController.text;

      // Criação real de conta no Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: senha);

      // Atualiza o nome de exibição do utilizador se preenchido
      if (_nomeController.text.trim().isNotEmpty) {
        await userCredential.user?.updateDisplayName(
          _nomeController.text.trim(),
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String mensagemErro = 'Erro ao criar conta.';
      if (e.code == 'weak-password') {
        mensagemErro = 'A senha fornecida é muito fraca.';
      } else if (e.code == 'email-already-in-use') {
        mensagemErro = 'Já existe uma conta com este e-mail.';
      } else if (e.code == 'invalid-email') {
        mensagemErro = 'O formato do e-mail é inválido.';
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensagemErro), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    }
  }

  // ============================================================
  // DATA DE NASCIMENTO
  // ============================================================

  Future<void> _selecionarDataNascimento() async {
    FocusScope.of(context).unfocus();

    final agora = DateTime.now();

    final data = await showDatePicker(
      context: context,
      initialDate: DateTime(agora.year - 18, agora.month, agora.day),
      firstDate: DateTime(1900),
      lastDate: agora,
      helpText: 'Selecione sua data de nascimento',
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (data == null) return;

    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year.toString();

    setState(() {
      _dataNascimentoController.text = '$dia/$mes/$ano';
    });
  }

  // ============================================================
  // IR PARA CRIAR CONTA / LOGIN
  // ============================================================

  void _irParaCriarConta() {
    setState(() {
      _criarConta = true;
      _nomeController.clear();
      _dataNascimentoController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();
      _aceitouTermos = false;
      _mostrarSenha = false;
      _mostrarConfirmarSenha = false;
    });
  }

  void _irParaLogin() {
    setState(() {
      _criarConta = false;
      _nomeController.clear();
      _dataNascimentoController.clear();
      _senhaController.clear();
      _confirmarSenhaController.clear();
      _aceitouTermos = false;
      _mostrarSenha = false;
      _mostrarConfirmarSenha = false;
    });
  }

  // ============================================================
  // BUILD PRINCIPAL
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: _criarConta ? _buildTelaCriarConta() : _buildTelaEntrar(),
        ),
      ),
    );
  }

  // ============================================================
  // TELA ENTRAR
  // ============================================================

  Widget _buildTelaEntrar() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                'Entre na sua conta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  height: 1.1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Organize seu tempo do seu jeito',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 45),
              const Text(
                'E-mail',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _CampoFigma(
                controller: _emailController,
                hintText: 'Digite seu e-mail',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  if (!valor.contains('@')) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 27),
              const Text(
                'Senha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _CampoFigma(
                controller: _senhaController,
                hintText: 'Digite sua senha',
                icon: Icons.lock_outline,
                obscureText: !_mostrarSenha,
                onTogglePassword: () {
                  setState(() {
                    _mostrarSenha = !_mostrarSenha;
                  });
                },
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Digite sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recuperação de senha em breve.'),
                      ),
                    );
                  },
                  child: const Text(
                    'Esqueceu sua senha?',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _entrar,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.6,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: _carregando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Entrar',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: _irParaCriarConta,
                  child: const Text(
                    'Não tem uma conta? Criar Conta',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TELA CRIAR CONTA
  // ============================================================

  Widget _buildTelaCriarConta() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image_outlined,
                      size: 64,
                      color: AppColors.primary,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Crie sua conta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  height: 1.05,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Organize seu tempo do seu jeito',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 44),
              const Text(
                'Nome',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _CampoFigma(
                controller: _nomeController,
                hintText: 'Digite seu nome',
                icon: Icons.person_outline,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Digite seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 27),
              const Text(
                'E-mail',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _CampoFigma(
                controller: _emailController,
                hintText: 'Digite seu e-mail',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (valor) {
                  if (valor == null || valor.trim().isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  if (!valor.contains('@')) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 27),
              const Text(
                'Data de nascimento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selecionarDataNascimento,
                child: AbsorbPointer(
                  child: _CampoFigma(
                    controller: _dataNascimentoController,
                    hintText: 'Digite sua data de nascimento',
                    icon: Icons.calendar_today_outlined,
                    keyboardType: TextInputType.datetime,
                    validator: (valor) {
                      if (valor == null || valor.trim().isEmpty) {
                        return 'Selecione sua data de nascimento';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 27),
              const Text(
                'Senha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _CampoFigma(
                controller: _senhaController,
                hintText: 'Digite sua senha',
                icon: Icons.lock_outline,
                obscureText: !_mostrarSenha,
                onTogglePassword: () {
                  setState(() {
                    _mostrarSenha = !_mostrarSenha;
                  });
                },
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Digite sua senha';
                  }
                  if (valor.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 27),
              const Text(
                'Confirmar senha',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              _CampoFigma(
                controller: _confirmarSenhaController,
                hintText: 'Digite novamente sua senha',
                icon: Icons.lock_outline,
                obscureText: !_mostrarConfirmarSenha,
                onTogglePassword: () {
                  setState(() {
                    _mostrarConfirmarSenha = !_mostrarConfirmarSenha;
                  });
                },
                validator: (valor) {
                  if (valor == null || valor.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (valor != _senhaController.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 34),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _aceitouTermos,
                      onChanged: (valor) {
                        setState(() {
                          _aceitouTermos = valor ?? false;
                        });
                      },
                      activeColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.hint, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Concordo com os Termos de Uso e Política de Privacidade',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.25,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: _carregando ? null : _criarNovaConta,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(
                      alpha: 0.6,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: _carregando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Criar Conta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: GestureDetector(
                  onTap: _irParaLogin,
                  child: const Text(
                    'Já tem uma conta? Entrar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// CAMPO PADRÃO
// ============================================================================

class _CampoFigma extends StatelessWidget {
  const _CampoFigma({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.onTogglePassword,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final VoidCallback? onTogglePassword;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: AppColors.primary,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: Color(0xFF5E5A63),
        ),
        prefixIcon: Icon(icon, size: 25, color: const Color(0xFF57525B)),
        suffixIcon: onTogglePassword != null
            ? IconButton(
                onPressed: onTogglePassword,
                splashRadius: 22,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 26,
                  color: const Color(0xFF57525B),
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(17),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(fontSize: 11),
      ),
    );
  }
}
