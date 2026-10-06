import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart'; //[cite: 5]

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
  ]; //[cite: 5]

  // Função centralizada para encerrar a sessão e limpar o histórico de navegação
  Future<void> _sairDaConta() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const TelaLogin(criarConta: false)),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao sair da conta: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isProfile = _currentIndex == 3;

    return Scaffold(
      body: _screens.isNotEmpty
          ? _screens[_currentIndex]
          : const Center(
              child: Text('Insira as telas na lista _screens'),
            ), //[cite: 5]
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
          : FloatingActionButtonLocation.centerDocked, //[cite: 5]
      // Barra de navegação inferior com Expanded para evitar overflow
      bottomNavigationBar: BottomAppBar(
        shape: isProfile ? null : const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: navBarItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Início',
                  index: 0,
                ),
              ),
              Expanded(
                child: navBarItem(
                  icon: Icons.bar_chart_outlined,
                  selectedIcon: Icons.bar_chart,
                  label: 'Progresso',
                  index: 1,
                ),
              ),

              // O espaço reservado só existe nas outras abas para acomodar o FAB
              if (!isProfile) const SizedBox(width: 32),

              Expanded(
                child: navBarItem(
                  icon: Icons.history_outlined,
                  selectedIcon: Icons.history,
                  label: 'Histórico',
                  index: 2,
                ),
              ),
              Expanded(
                child: navBarItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Perfil',
                  index: 3,
                ),
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
