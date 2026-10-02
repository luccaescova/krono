import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProgressScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Verifica se está na aba de Perfil (índice 3)
    final bool isProfile = _currentIndex == 3;

    return Scaffold(
      body: _screens.isNotEmpty
          ? _screens[_currentIndex]
          : const Center(child: Text('Insira as telas na lista _screens')),

      // Botão Central Flutuante (Some se estiver na aba Perfil)
      floatingActionButton: isProfile
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Ação ao clicar no botão central de adicionar
              },
              backgroundColor: const Color(0xFF0649B8),
              elevation: 4,
              shape: const CircleBorder(),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
      floatingActionButtonLocation: isProfile
          ? null
          : FloatingActionButtonLocation.centerDocked,

      // Barra de navegação inferior
      bottomNavigationBar: BottomAppBar(
        shape: isProfile ? null : const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navBarItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Início',
                index: 0,
              ),
              navBarItem(
                icon: Icons.bar_chart_outlined,
                selectedIcon: Icons.bar_chart,
                label: 'Progresso',
                index: 1,
              ),

              // O espaço reservado só existe nas outras abas
              if (!isProfile) const SizedBox(width: 40),

              navBarItem(
                icon: Icons.history_outlined,
                selectedIcon: Icons.history,
                label: 'Histórico',
                index: 2,
              ),
              navBarItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Perfil',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navBarItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? const Color(0xFF0649B8)
        : const Color(0xFF677184);

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSelected ? selectedIcon : icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
