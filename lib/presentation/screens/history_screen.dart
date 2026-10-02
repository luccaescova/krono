import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool currentWeek = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Histórico',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF303846),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Revise suas rotinas e acompanhe sua constância.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF677184)),
                ),
                const SizedBox(height: 12),

                // SELETOR DE SEMANA
                Container(
                  height: 40,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF1FC),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      weekButton('Esta semana', true),
                      weekButton('Semana passada', false),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // RESUMO
                Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFD9E0EA)),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1FC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.calendar_today_outlined,
                          size: 17,
                          color: Color(0xFF0649B8),
                        ),
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentWeek
                                  ? '23–29 de Outubro'
                                  : '16–22 de Outubro',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF303846),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              '18 de 23 rotinas concluídas',
                              style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF677184),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        '78%',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF16845B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                if (currentWeek) ...[
                  dayCard(
                    day: 'Quarta-feira, 25 de Outubro',
                    progress: '6 de 8 rotinas concluídas (75%)',
                    percentage: '75%',
                    tasks: const [
                      ['08:30', 'Café da manhã & Meditação', true],
                      ['09:00', 'Reunião de Equipe - Planejamento', true],
                      ['10:30', 'Estudar Arquitetura Flutter', true],
                      ['12:00', 'Almoço e Descanso', false],
                    ],
                  ),
                  dayCard(
                    day: 'Terça-feira, 24 de Outubro',
                    progress: '7 de 7 rotinas concluídas (100%)',
                    percentage: '100%',
                    tasks: const [
                      ['08:00', 'Revisão das prioridades', true],
                      ['14:00', 'Bloco de foco - Projeto Krono', true],
                    ],
                  ),
                  dayCard(
                    day: 'Segunda-feira, 23 de Outubro',
                    progress: '5 de 8 rotinas concluídas (63%)',
                    percentage: '63%',
                    tasks: const [
                      ['09:15', 'Planejamento semanal', true],
                      ['18:30', 'Leitura e anotações', true],
                    ],
                  ),
                ] else ...[
                  dayCard(
                    day: 'Domingo, 22 de Outubro',
                    progress: '5 de 6 rotinas concluídas (83%)',
                    percentage: '83%',
                    tasks: const [
                      ['08:00', 'Organizar a semana', true],
                      ['10:00', 'Leitura e estudos', true],
                    ],
                  ),
                  dayCard(
                    day: 'Sábado, 21 de Outubro',
                    progress: '4 de 5 rotinas concluídas (80%)',
                    percentage: '80%',
                    tasks: const [
                      ['09:00', 'Atividade física', true],
                      ['14:00', 'Estudar programação', true],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget header() {
    return Container(
      height: 96,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'krono',
            style: TextStyle(
              color: Color(0xFF0649B8),
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(width: 14),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bom dia,',
                style: TextStyle(fontSize: 10, color: Color(0xFF677184)),
              ),
              SizedBox(height: 3),
              Text(
                'Lucca Scovini',
                style: TextStyle(fontSize: 12, color: Color(0xFF303846)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF1FC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, color: Color(0xFF0649B8)),
          ),
        ],
      ),
    );
  }

  Widget weekButton(String label, bool isCurrent) {
    final selected = currentWeek == isCurrent;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            currentWeek = isCurrent;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: selected
                  ? const Color(0xFF0649B8)
                  : const Color(0xFF677184),
              fontWeight: selected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget dayCard({
    required String day,
    required String progress,
    required String percentage,
    required List<List<dynamic>> tasks,
  }) {
    final complete = percentage == '100%';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(11, 10, 11, 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFD9E0EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF303846),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      progress,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF677184),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: complete
                      ? const Color(0xFFE7F5EF)
                      : const Color(0xFFEAF1FC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  percentage,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: complete
                        ? const Color(0xFF16845B)
                        : const Color(0xFF0649B8),
                  ),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, color: Color(0xFFE5EAF0)),
          ),
          ...tasks.map((task) {
            final done = task[2] as bool;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Icon(
                    done ? Icons.check_circle : Icons.remove_circle,
                    size: 14,
                    color: done
                        ? const Color(0xFF16845B)
                        : const Color(0xFF9AA5B5),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${task[0]} · ${task[1]}',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF303846),
                      ),
                    ),
                  ),
                  if (!done)
                    const Text(
                      'Adiado',
                      style: TextStyle(fontSize: 9, color: Color(0xFFF0A323)),
                    ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
