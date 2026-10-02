import 'package:flutter/material.dart';
import 'presentation/screens/main_navigation_screen.dart';

void main() {
  runApp(const KronoApp());
}

class KronoApp extends StatelessWidget {
  const KronoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Krono',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF0033CC),
        scaffoldBackgroundColor: const Color(0xFFF5F5F0),
      ),
      home: const MainNavigationScreen(),
    );
  }
}
