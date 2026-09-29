import 'package:flutter/material.dart';

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
      // Configuração do Tema com Material 3 e cores sóbrias/focadas em produtividade
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const KronoHomePage(),
    );
  }
}

class KronoHomePage extends StatelessWidget {
  const KronoHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Krono — Minha Rotina'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Seu dia começa aqui.',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ação para adicionar nova rotina
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}