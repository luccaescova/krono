import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/intro_screen.dart'; // Certifique-se de que o caminho corresponde à pasta onde está a TelaInicial
import 'theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const KronoApp());
}

class KronoApp extends StatelessWidget {
  const KronoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Krono',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            primaryColor: const Color(0xFF0033CC),
            scaffoldBackgroundColor: const Color(0xFFF5F5F0),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0033CC),
              brightness: Brightness.light,
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF0033CC),
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0033CC),
              brightness: Brightness.dark,
            ),
          ),

          themeMode: themeController.isDarkMode
              ? ThemeMode.dark
              : ThemeMode.light,

          // Tela inicial de roteamento que decide se o utilizador vai para a intro ou para o app principal
          home: const InitialAuthWrapper(),
        );
      },
    );
  }
}

/// Widget responsável por verificar o estado de autenticação inicial
/// e fazer a transição correta entre a tela inicial (intro) e o app principal.
class InitialAuthWrapper extends StatelessWidget {
  const InitialAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Se quiser verificar se o utilizador já está logado via Firebase Auth,
    // pode usar um StreamBuilder com FirebaseAuth.instance.authStateChanges().
    // Por enquanto, inicia diretamente na TelaInicial (intro_screen.dart).
    return const TelaInicial();
  }
}
