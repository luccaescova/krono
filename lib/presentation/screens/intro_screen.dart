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
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 5),

                // =========================
                // LOGO KRONO
                // =========================
                const LogoKrono(),

                // Espaço menor entre o logo e o texto
                const SizedBox(height: 8),

                // =========================
                // FRASE
                // =========================
                const Text(
                  'Organize seu tempo do seu jeito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: kronoMuted,
                  ),
                ),

                const SizedBox(height: 78),

                // =========================
                // BOTÃO CRIAR CONTA
                // =========================
                SizedBox(
                  width: double.infinity,
                  height: 68,
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
                          builder: (context) {
                            return const TelaLogin(
                              criarConta: true,
                            );
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Criar Conta',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // BOTÃO ENTRAR
                // =========================
                SizedBox(
                  width: double.infinity,
                  height: 68,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: kronoText,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFFE0E3E8),
                      ),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const TelaLogin();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ======================================================
// LOGO KRONO
// ======================================================

class LogoKrono extends StatelessWidget {
  const LogoKrono({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      height: 360,
      child: Image.asset(
        'assets/images/logo_with_text_down.png',
        width: 360,
        height: 360,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
            'Erro ao carregar logo_with_text_down.png: $error',
          );

          return const Icon(
            Icons.broken_image_outlined,
            size: 80,
            color: kronoBlue,
          );
        },
      ),
    );
  }
}