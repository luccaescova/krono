import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedDay = 2;

  final List<String> days = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex'];
  final List<int> dates = [23, 24, 25, 26, 27];

  final List<Map<String, dynamic>> routines = [
    {
      'time': '08:30',
      'title': 'Café da manhã &',
      'subtitle': 'Meditação',
      'icon': Icons.coffee_outlined,
      'color': const Color(0xFF0649B8),
      'background': const Color(0xFFEAF1FC),
      'completed': false,
    },
    {
      'time': '09:00',
      'title': 'Reunião de Equipe -',
      'subtitle': 'Planejamento',
      'icon': Icons.assignment_turned_in_outlined,
      'color': const Color(0xFF16845B),
      'background': const Color(0xFFE7F5EF),
      'completed': true,
    },
    {
      'time': '10:30',
      'title': 'Estudar Arquitetura',
      'subtitle': 'Flutter',
      'icon': Icons.menu_book_outlined,
      'color': const Color(0xFF9852C8),
      'background': const Color(0xFFF2EAF9),
      'completed': false,
    },
    {
      'time': '12:00',
      'title': 'Almoço e Descanso',
      'subtitle': '',
      'icon': Icons.restaurant_outlined,
      'color': const Color(0xFFF0A323),
      'background': const Color(0xFFFFF4DF),
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        header(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quarta-feira, 25 de Outubro',
                  style: TextStyle(fontSize: 19, color: Color(0xFF303846)),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Bom dia, Lucca. Vamos organizar seu dia?',
                  style: TextStyle(fontSize: 12, color: Color(0xFF677184)),
                ),

                const SizedBox(height: 18),

                // SELEÇÃO DE DATA
                Row(
                  children: List.generate(days.length, (index) {
                    final selected = selectedDay == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDay = index;
                          });
                        },
                        child: Container(
                          height: 55,
                          margin: EdgeInsets.only(right: index == 4 ? 0 : 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFF0649B8)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(9),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF0649B8)
                                  : const Color(0xFFD9E0EA),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                days[index],
                                style: TextStyle(
                                  fontSize: 12,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF677184),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${dates[index]}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? Colors.white
                                      : const Color(0xFF303846),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 19),

                const Text(
                  'Rotinas de hoje',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF303846),
                  ),
                ),

                const SizedBox(height: 12),

                ...List.generate(
                  routines.length,
                  (index) => routineCard(index),
                ),
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

  Widget routineCard(int index) {
    final routine = routines[index];

    return Container(
      height: 66,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: const Color(0xFFD9E0EA)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: routine['color'],
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(9),
              ),
            ),
          ),
          const SizedBox(width: 7),

          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: routine['background'],
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(routine['icon'], color: routine['color'], size: 21),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${routine['time']} · ${routine['title']}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF677184),
                  ),
                ),
                if (routine['subtitle'] != '')
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      routine['subtitle'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF677184),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Checkbox(
            value: routine['completed'],
            activeColor: const Color(0xFF9AA5B5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (value) {
              setState(() {
                routine['completed'] = value!;
              });
            },
          ),

          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
