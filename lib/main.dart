import 'package:flutter/material.dart';
import 'presentation/screens/main_navigation_screen.dart';
import 'theme_controller.dart';

void main() {
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

          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
