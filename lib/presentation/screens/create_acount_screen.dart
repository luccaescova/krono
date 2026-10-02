import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  static const primary = Color(0xFF003CA5);
  static const background = Color(0xFFF3F4F6);
  static const border = Color(0xFFD1D5DB);
  static const hint = Color(0xFF9CA3AF);
  static const textSecondary = Color(0xFF6B7280);
  static const textPrimary = Color(0xFF111827);
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _birthController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (date != null) {
      final d = date.day.toString().padLeft(2, '0');
      final m = date.month.toString().padLeft(2, '0');
      _birthController.text = '$d/$m/${date.year}';
    }
  }

  void _submit() {
    // Validação ou chamada de cadastro
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
                // Botão voltar atualizado com a seta correta
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Criar Conta no Krono',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            height: 1.0,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'Comece a organizar a sua rotina agora.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 44.5),
                      _AppTextField(
                        hint: 'Nome completo:',
                        icon: Icons.person_outline,
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const _FieldGap(),
                      _AppTextField(
                        hint: 'Email:',
                        icon: Icons.mail_outline,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const _FieldGap(),
                      _AppTextField(
                        hint: 'Data de nascimento:',
                        icon: Icons.calendar_today_outlined,
                        controller: _birthController,
                        readOnly: true,
                        onTap: _pickBirthDate,
                      ),
                      const _FieldGap(),
                      _AppTextField(
                        hint: 'Senha:',
                        icon: Icons.lock_outline,
                        controller: _passwordController,
                        obscureText: _hidePassword,
                        onToggleObscure: () =>
                            setState(() => _hidePassword = !_hidePassword),
                      ),
                      const _FieldGap(),
                      _AppTextField(
                        hint: 'Confirmar senha:',
                        icon: Icons.lock_outline,
                        controller: _confirmController,
                        obscureText: _hideConfirm,
                        onToggleObscure: () =>
                            setState(() => _hideConfirm = !_hideConfirm),
                      ),
                      const SizedBox(height: 47),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 2.2),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () => setState(
                                () => _acceptedTerms = !_acceptedTerms,
                              ),
                              child: _TermsCheckbox(checked: _acceptedTerms),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Expanded(
                            child: Text(
                              'Concordo com os Termos de Uso e Política de Privacidade',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.5,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22.5),
                      SizedBox(
                        height: 40.3,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Criar Conta'),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
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

class _FieldGap extends StatelessWidget {
  const _FieldGap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 13.33);
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.hint,
    required this.icon,
    required this.controller,
    this.obscureText = false,
    this.onToggleObscure,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool obscureText;
  final VoidCallback? onToggleObscure;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

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
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              readOnly: readOnly,
              onTap: onTap,
              keyboardType: keyboardType,
              textCapitalization: textCapitalization,
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

class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 11.25,
      height: 11.25,
      decoration: BoxDecoration(
        color: checked ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(2.5),
        border: Border.all(
          color: checked ? AppColors.primary : AppColors.hint,
          width: 1.25,
        ),
      ),
      child: checked
          ? const Icon(Icons.check, size: 8, color: Colors.white)
          : null,
    );
  }
}
