import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

const Color _azul = Color(0xFF0649BD);
const Color _azulClaro = Color(0xFFEAF1FE);
const Color _fundo = Color(0xFFF5F8FC);
const Color _texto = Color(0xFF202938);
const Color _secundario = Color(0xFF6F7D96);
const Color _borda = Color(0xFFD9E1EC);
const Color _verde = Color(0xFF14865F);
const Color _roxo = Color(0xFF8D4AB7);

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: _fundo,
      body: SafeArea(
        child: Column(
          children: [
            _BarraTopo(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  children: [
                    _ResumoSemanal(),
                    SizedBox(height: 10),
                    _CartaoFocoConsecutivo(),
                    SizedBox(height: 10),
                    _DistribuicaoRotinas(),
                    SizedBox(height: 10),
                    _ConsistenciaDiaria(),
                    SizedBox(height: 10),
                    _PomodoroCard(),
                    SizedBox(height: 10),
                    _RotinasFlexiveis(),
                    SizedBox(height: 10),
                    _AssistenteAntiestresse(),
                    SizedBox(height: 10),
                    _ConquistasDiarias(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraTopo extends StatelessWidget {
  const _BarraTopo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          const SizedBox(
            width: 92,
            child: Text(
              'Krono',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                color: _azul,
              ),
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bom dia,',
                  style: TextStyle(fontSize: 11, color: _secundario),
                ),
                SizedBox(height: 3),
                Text(
                  'Lucca Scovini',
                  style: TextStyle(
                    fontSize: 12,
                    color: _texto,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: _azulClaro,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 32, color: _azul),
          ),
        ],
      ),
    );
  }
}

class _Cartao extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const _Cartao({required this.child, this.padding = const EdgeInsets.all(12)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _borda),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class _RotuloLinha extends StatelessWidget {
  final String titulo;
  final String? etiqueta;

  const _RotuloLinha(this.titulo, {this.etiqueta});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF303847),
            ),
          ),
        ),
        if (etiqueta != null) _Pill(etiqueta!),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String texto;

  const _Pill(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _azulClaro,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        texto,
        style: const TextStyle(
          fontSize: 9,
          color: _azul,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ResumoSemanal extends StatelessWidget {
  const _ResumoSemanal();

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RotuloLinha('Resumo semanal', etiqueta: 'Esta semana'),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox(
                width: 94,
                height: 94,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: .78,
                        strokeWidth: 10,
                        backgroundColor: _azulClaro,
                        valueColor: AlwaysStoppedAnimation(_azul),
                      ),
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '78%',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: _texto,
                          ),
                        ),
                        Text(
                          'concluído',
                          style: TextStyle(fontSize: 9, color: _secundario),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '65 de 83 rotinas concluídas',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF343B49),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Continue avançando um passo de cada vez.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: _secundario,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.trending_up, size: 15, color: _verde),
                        SizedBox(width: 4),
                        Text(
                          'Ritmo em alta',
                          style: TextStyle(
                            fontSize: 10,
                            color: _verde,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartaoFocoConsecutivo extends StatelessWidget {
  const _CartaoFocoConsecutivo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: _azulClaro,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.local_fire_department_outlined, color: _azul, size: 30),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Maior foco consecutivo: 3 dias',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Mantenha o ritmo para alcançar seu recorde.',
                  style: TextStyle(fontSize: 9, color: _secundario),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DistribuicaoRotinas extends StatelessWidget {
  const _DistribuicaoRotinas();

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribuição de rotinas',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF303847),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(
                width: 96,
                height: 96,
                child: CustomPaint(painter: _PizzaPainter()),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  children: [
                    _Legenda(cor: _azul, titulo: 'Trabalho', valor: '40%'),
                    SizedBox(height: 8),
                    _Legenda(cor: _verde, titulo: 'Saúde', valor: '30%'),
                    SizedBox(height: 8),
                    _Legenda(cor: _roxo, titulo: 'Estudos', valor: '30%'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PizzaPainter extends CustomPainter {
  const _PizzaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = math.min(size.width, size.height) / 2;

    const values = [0.4, 0.3, 0.3];
    const colors = [_azul, _verde, _roxo];

    var start = -math.pi / 2;

    for (var i = 0; i < values.length; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        values[i] * math.pi * 2,
        true,
        Paint()..color = colors[i],
      );

      start += values[i] * math.pi * 2;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Legenda extends StatelessWidget {
  final Color cor;
  final String titulo;
  final String valor;

  const _Legenda({
    required this.cor,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            titulo,
            style: const TextStyle(fontSize: 9, color: _secundario),
          ),
        ),
        Text(valor, style: const TextStyle(fontSize: 9, color: _secundario)),
      ],
    );
  }
}

// CHECKBOXES DA CONSISTÊNCIA DIÁRIA

class _ConsistenciaDiaria extends StatefulWidget {
  const _ConsistenciaDiaria();

  @override
  State<_ConsistenciaDiaria> createState() => _ConsistenciaDiariaState();
}

class _ConsistenciaDiariaState extends State<_ConsistenciaDiaria> {
  final List<bool> _marcados = List<bool>.filled(7, false);

  final List<String> _dias = const [
    'Qua 19',
    'Qui 20',
    'Sex 21',
    'Sáb 22',
    'Dom 23',
    'Seg 24',
    'Ter 25',
  ];

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RotuloLinha('Consistência diária', etiqueta: 'Últimos 7 dias'),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              _dias.length,
              (i) => Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      _marcados[i] = !_marcados[i];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      children: [
                        Container(
                          width: 29,
                          height: 29,
                          decoration: BoxDecoration(
                            color: _marcados[i]
                                ? _verde
                                : const Color(0xFFE8EDF5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _marcados[i] ? Icons.check : Icons.add,
                            size: 18,
                            color: _marcados[i] ? Colors.white : _secundario,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _dias[i],
                          style: const TextStyle(
                            fontSize: 8,
                            color: _secundario,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            '${_marcados.where((v) => v).length} de 7 dias marcados',
            style: const TextStyle(fontSize: 10, color: _secundario),
          ),
        ],
      ),
    );
  }
}

// POMODORO FUNCIONAL

class _PomodoroCard extends StatefulWidget {
  const _PomodoroCard();

  @override
  State<_PomodoroCard> createState() => _PomodoroCardState();
}

class _PomodoroCardState extends State<_PomodoroCard> {
  static const int _focoSegundos = 25 * 60;
  static const int _pausaSegundos = 5 * 60;

  Timer? _timer;

  int _restantes = _focoSegundos;
  int _ciclo = 1;

  bool _rodando = false;
  bool _emPausa = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _tempo {
    final minutos = (_restantes ~/ 60).toString().padLeft(2, '0');

    final segundos = (_restantes % 60).toString().padLeft(2, '0');

    return '$minutos:$segundos';
  }

  void _alternar() {
    if (_rodando) {
      _timer?.cancel();

      setState(() {
        _rodando = false;
      });

      return;
    }

    setState(() {
      _rodando = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_restantes <= 1) {
        timer.cancel();

        setState(() {
          _rodando = false;
          _emPausa = !_emPausa;

          _restantes = _emPausa ? _pausaSegundos : _focoSegundos;

          if (!_emPausa) {
            _ciclo = _ciclo % 4 + 1;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _emPausa
                  ? 'Foco concluído! Hora de fazer uma pausa.'
                  : 'Pausa concluída! Vamos focar.',
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          _restantes--;
        });
      }
    });
  }

  void _reiniciar() {
    _timer?.cancel();

    setState(() {
      _rodando = false;
      _emPausa = false;
      _ciclo = 1;
      _restantes = _focoSegundos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _emPausa ? _pausaSegundos : _focoSegundos;

    final progresso = 1 - (_restantes / total);

    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RotuloLinha(
            'Modo Foco com Pomodoro',
            etiqueta: 'Temporizador',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _fundo,
              border: Border.all(color: const Color(0xFFE3EAF4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _azulClaro,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Icon(
                        _emPausa
                            ? Icons.coffee_outlined
                            : Icons.center_focus_strong,
                        color: _azul,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _emPausa ? 'Pausa Pomodoro' : 'Pomodoro',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _texto,
                            ),
                          ),
                          Text(
                            _emPausa
                                ? 'Descanse por 5 minutos'
                                : 'Ciclo de foco de 25 minutos',
                            style: const TextStyle(
                              fontSize: 9,
                              color: _secundario,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: _rodando ? 'Pausar' : 'Iniciar',
                      onPressed: _alternar,
                      icon: Icon(
                        _rodando
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: _verde,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Reiniciar',
                      onPressed: _reiniciar,
                      icon: const Icon(Icons.restart_alt, color: _secundario),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _tempo,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: _texto,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _rodando
                      ? (_emPausa ? 'Pausa em andamento' : 'Foco em andamento')
                      : 'Temporizador pausado',
                  style: const TextStyle(fontSize: 9, color: _secundario),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: progresso,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFE4EAF3),
                    valueColor: const AlwaysStoppedAnimation(_azul),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ciclo $_ciclo de 4',
                        style: const TextStyle(fontSize: 9, color: _secundario),
                      ),
                    ),
                    Text(
                      _emPausa ? 'Pausa de 5 min' : 'Foco de 25 min',
                      style: const TextStyle(fontSize: 9, color: _secundario),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _EtapaPomodoro(
                      numero: '1',
                      titulo: 'Foco',
                      tempo: '25 min',
                      ativo: _ciclo == 1 && !_emPausa,
                    ),
                    _EtapaPomodoro(
                      numero: '2',
                      titulo: 'Pausa',
                      tempo: '5 min',
                      ativo: _emPausa,
                    ),
                    _EtapaPomodoro(
                      numero: '3',
                      titulo: 'Foco',
                      tempo: '25 min',
                      ativo: _ciclo >= 3 && !_emPausa,
                    ),
                    const _EtapaPomodoro(
                      numero: '4',
                      titulo: 'Pausa',
                      tempo: '5 min',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EtapaPomodoro extends StatelessWidget {
  final String numero;
  final String titulo;
  final String tempo;
  final bool ativo;

  const _EtapaPomodoro({
    required this.numero,
    required this.titulo,
    required this.tempo,
    this.ativo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 27,
          height: 27,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ativo ? _verde : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: ativo ? _verde : _borda),
          ),
          child: Text(
            numero,
            style: TextStyle(
              fontSize: 10,
              color: ativo ? Colors.white : _secundario,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(titulo, style: const TextStyle(fontSize: 9, color: _texto)),
        const SizedBox(height: 5),
        Text(tempo, style: const TextStyle(fontSize: 8, color: _secundario)),
      ],
    );
  }
}

// ROTINAS FLEXÍVEIS COM CHECKBOXES

class _RotinasFlexiveis extends StatefulWidget {
  const _RotinasFlexiveis();

  @override
  State<_RotinasFlexiveis> createState() => _RotinasFlexiveisState();
}

class _RotinasFlexiveisState extends State<_RotinasFlexiveis> {
  final List<bool> _feitas = [false, false, false];

  final List<String> _titulos = ['Acordar', 'Café', 'Alongamento'];

  final List<String> _subtitulos = [
    'Quando acordar',
    'Depois de acordar',
    'Depois do café',
  ];

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RotuloLinha(
            'Rotinas Flexíveis',
            etiqueta: '${_feitas.where((v) => v).length}/3 feitas',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _fundo,
              border: Border.all(color: const Color(0xFFE3EAF4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manhã Produtiva',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Marque cada rotina conforme for concluindo.',
                  style: TextStyle(fontSize: 9, color: _secundario),
                ),
                const SizedBox(height: 8),
                for (var i = 0; i < _titulos.length; i++) ...[
                  if (i > 0) const Divider(height: 1, color: _borda),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: _verde,
                    value: _feitas[i],
                    onChanged: (v) {
                      setState(() {
                        _feitas[i] = v ?? false;
                      });
                    },
                    title: Text(
                      _titulos[i],
                      style: TextStyle(
                        fontSize: 11,
                        color: _texto,
                        decoration: _feitas[i]
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      _subtitulos[i],
                      style: const TextStyle(fontSize: 9, color: _secundario),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// EXERCÍCIO DE RESPIRAÇÃO E BOTÕES DE SONS

class _AssistenteAntiestresse extends StatefulWidget {
  const _AssistenteAntiestresse();

  @override
  State<_AssistenteAntiestresse> createState() =>
      _AssistenteAntiestresseState();
}

class _AssistenteAntiestresseState extends State<_AssistenteAntiestresse> {
  String? _selecionado;

  bool _respiracaoAtiva = false;

  Timer? _timer;

  int _segundos = 60;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarRespiracao() {
    _timer?.cancel();

    setState(() {
      _selecionado = 'Respiração guiada';
      _respiracaoAtiva = true;
      _segundos = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_segundos <= 1) {
        timer.cancel();

        setState(() {
          _segundos = 0;
          _respiracaoAtiva = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exercício de respiração concluído!')),
        );
      } else {
        setState(() {
          _segundos--;
        });
      }
    });
  }

  void _alternarSom(String som) {
    setState(() {
      _selecionado = _selecionado == som ? null : som;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _selecionado == null
              ? 'Som desativado.'
              : '$som selecionado. Para reproduzir áudio, conecte um arquivo de som ao app.',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _RotuloLinha(
            'Assistente de Pausa Antiestresse',
            etiqueta: 'Acesso rápido',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _fundo,
              border: Border.all(color: const Color(0xFFE3EAF4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Respiração guiada',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _respiracaoAtiva
                      ? 'Respire devagar... $_segundos segundos restantes'
                      : '1 minuto para fazer uma pausa e respirar.',
                  style: const TextStyle(fontSize: 9, color: _secundario),
                ),
                const SizedBox(height: 9),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _respiracaoAtiva
                        ? () {
                            _timer?.cancel();
                            setState(() {
                              _respiracaoAtiva = false;
                            });
                          }
                        : _iniciarRespiracao,
                    icon: Icon(_respiracaoAtiva ? Icons.stop : Icons.air),
                    label: Text(
                      _respiracaoAtiva
                          ? 'Encerrar exercício'
                          : 'Iniciar respiração (1 min)',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _azul,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sons ambientes',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _texto,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _SomBotao(
                        titulo: 'Chuva',
                        icone: Icons.water_drop_outlined,
                        ativo: _selecionado == 'Chuva',
                        onTap: () => _alternarSom('Chuva'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _SomBotao(
                        titulo: 'Ruído branco',
                        icone: Icons.graphic_eq,
                        ativo: _selecionado == 'Ruído branco',
                        onTap: () => _alternarSom('Ruído branco'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SomBotao extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final bool ativo;
  final VoidCallback onTap;

  const _SomBotao({
    required this.titulo,
    required this.icone,
    required this.ativo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(ativo ? Icons.stop_circle_outlined : icone, size: 18),
      label: Text(
        ativo ? 'Parar $titulo' : titulo,
        textAlign: TextAlign.center,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: ativo ? Colors.white : _azul,
        backgroundColor: ativo ? _azul : Colors.white,
        side: const BorderSide(color: _borda),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
    );
  }
}

// CONQUISTAS COM CHECKBOXES

class _ConquistasDiarias extends StatefulWidget {
  const _ConquistasDiarias();

  @override
  State<_ConquistasDiarias> createState() => _ConquistasDiariasState();
}

class _ConquistasDiariasState extends State<_ConquistasDiarias> {
  final List<bool> _concluidas = [false, false, false];

  final List<String> _titulos = [
    'Foco mantido',
    'Tarefas concluídas',
    'Sequência concluída',
  ];

  final List<String> _subtitulos = [
    'Complete seus ciclos de foco',
    'Finalize suas rotinas do dia',
    'Finalize a rotina Manhã Produtiva',
  ];

  final List<IconData> _icones = [
    Icons.local_fire_department_outlined,
    Icons.check_box_outlined,
    Icons.keyboard_arrow_down,
  ];

  @override
  Widget build(BuildContext context) {
    return _Cartao(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RotuloLinha(
            'Conquistas Diárias',
            etiqueta: '${_concluidas.where((v) => v).length}/3',
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _fundo,
              border: Border.all(color: const Color(0xFFE3EAF4)),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Column(
              children: List.generate(
                3,
                (i) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: _verde,
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _concluidas[i],
                  onChanged: (v) {
                    setState(() {
                      _concluidas[i] = v ?? false;
                    });
                  },
                  secondary: Icon(_icones[i], color: _azul, size: 23),
                  title: Text(
                    _titulos[i],
                    style: TextStyle(
                      fontSize: 10,
                      color: _texto,
                      decoration: _concluidas[i]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    _subtitulos[i],
                    style: const TextStyle(fontSize: 8, color: _secundario),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
