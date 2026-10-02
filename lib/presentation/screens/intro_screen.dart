import 'package:flutter/material.dart';
import 'login_screen.dart'; // Certifique-se de importar o arquivo de login

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
                const LogoKrono(tamanho: 112),
                const SizedBox(height: 20),
                const Text(
                  'krono',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: kronoText,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Organize seu tempo do seu jeito',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: kronoMuted),
                ),
                const SizedBox(height: 56),
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

class LogoKrono extends StatelessWidget {
  final double tamanho;

  const LogoKrono({super.key, this.tamanho = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamanho,
      height: tamanho,
      child: CustomPaint(painter: LogoKronoPainter()),
    );
  }
}

class LogoKronoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.width / 100;

    final Paint azul = Paint()
      ..color = kronoBlue
      ..style = PaintingStyle.fill;

    final Paint branco = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      azul,
    );

    final Path k = Path()
      ..moveTo(34 * s, 25 * s)
      ..lineTo(34 * s, 75 * s)
      ..moveTo(34 * s, 51 * s)
      ..lineTo(66 * s, 28 * s)
      ..moveTo(43 * s, 45 * s)
      ..lineTo(67 * s, 73 * s);

    canvas.drawPath(k, branco);

    final Paint detalhe = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Path seta = Path()
      ..moveTo(59 * s, 23 * s)
      ..lineTo(75 * s, 23 * s)
      ..lineTo(75 * s, 39 * s)
      ..close();

    canvas.drawPath(seta, detalhe);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
