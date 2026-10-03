import 'package:flutter/material.dart';
import 'login_screen.dart';

const Color kronoBlue = Color(0xFF003CA5);
const Color kronoText = Color(0xFF111827);
const Color kronoMuted = Color(0xFF6B7280);

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Logo carregado da imagem real
                const LogoKrono(tamanho: 112),

                const SizedBox(height: 20),

                const SizedBox(height: 12),

                const Text(
                  'Organize seu tempo do seu jeito',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: kronoMuted),
                ),

                const SizedBox(height: 56),

                // Botão Criar Conta
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kronoBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TelaLogin(criarConta: true),
                        ),
                      );
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kronoText,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFE0E3E8)),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const TelaLogin()),
                      );
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget que exibe o arquivo de imagem do logo
class LogoKrono extends StatelessWidget {
  final double tamanho;

  const LogoKrono({super.key, this.tamanho = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamanho,
      height: tamanho,
      child: Image.asset(
        'assets/images/logo_with_text_down.png',
        width: tamanho,
        height: tamanho,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Erro ao carregar logo_with_text_down.png: $error');

          return const Icon(
            Icons.broken_image_outlined,
            size: 48,
            color: kronoBlue,
          );
        },
      ),
    );
  }
}
