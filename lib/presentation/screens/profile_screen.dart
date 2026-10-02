import 'package:flutter/material.dart';
import 'intro_screen.dart'; // Certifique-se de importar a tela inicial

const Color _azul = Color(0xFF0649BD);
const Color _azulClaro = Color(0xFFEAF1FE);
const Color _secundario = Color(0xFF6F7D96);
const Color _borda = Color(0xFFD9E1EC);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _BarraTopo(titulo: 'Meu Perfil'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                children: [
                  const SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: 112,
                      height: 112,
                      decoration: const BoxDecoration(
                        color: _azulClaro,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 66,
                        color: _azul,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Lucca Scovini',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF202938),
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Usuário Premium',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: _secundario),
                  ),
                  const SizedBox(height: 32),
                  const _TituloSecao('Configurações Pessoais'),
                  const SizedBox(height: 10),
                  _GrupoOpcoes(
                    itens: const [
                      _Opcao(Icons.settings_outlined, 'Conta e Segurança'),
                      _Opcao(Icons.notifications_none_outlined, 'Notificações'),
                      _Opcao(Icons.palette_outlined, 'Aparência (Tema Claro)'),
                      _Opcao(Icons.shield_outlined, 'Privacidade'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const _TituloSecao('Sobre o Krono'),
                  const SizedBox(height: 10),
                  _GrupoOpcoes(
                    itens: const [
                      _Opcao(Icons.star_border_rounded, 'Avaliar na App Store'),
                      _Opcao(Icons.help_outline_rounded, 'Central de Ajuda'),
                      _Opcao(Icons.description_outlined, 'Termos de Uso'),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 62,
                    child: ElevatedButton(
                      onPressed: () {
                        // Lógica para sair da conta e voltar à Tela Inicial limpando o histórico
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TelaInicial(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _azul,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text(
                        'Sair da Conta',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraTopo extends StatelessWidget {
  final String titulo;

  const _BarraTopo({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF303846),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'krono',
                style: TextStyle(
                  color: _azul,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.5,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: _azulClaro,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, size: 24, color: _azul),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TituloSecao extends StatelessWidget {
  final String texto;

  const _TituloSecao(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        color: Color(0xFF343B49),
      ),
    );
  }
}

class _Opcao {
  final IconData icone;
  final String texto;

  const _Opcao(this.icone, this.texto);
}

class _GrupoOpcoes extends StatelessWidget {
  final List<_Opcao> itens;

  const _GrupoOpcoes({required this.itens});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _borda, width: 1.2),
        borderRadius: BorderRadius.circular(15),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < itens.length; i++) ...[
            if (i > 0) const Divider(height: 1, thickness: 1, color: _borda),
            SizedBox(
              height: 68,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      Icon(itens[i].icone, size: 29, color: _secundario),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          itens[i].texto,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color(0xFF353D4C),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        size: 28,
                        color: Color(0xFF9AA6B8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
