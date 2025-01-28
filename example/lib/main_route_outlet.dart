import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador Recursivo de Navegação',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/route1': (context) => const RoutePage(title: 'Rota 1'),
        '/route2': (context) => const RoutePage(title: 'Rota 2'),
        '/route10': (context) => const RecursiveNavigator(level: 1),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/route10');
          },
          child: const Text('Ir para Navegador Recursivo'),
        ),
      ),
    );
  }
}

class RoutePage extends StatelessWidget {
  final String title;

  const RoutePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}

class RecursiveNavigator extends StatelessWidget {
  final int level;

  const RecursiveNavigator({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nível $level'),
        leading: level > 1
            ? BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
      ),
      body: Navigator(
        initialRoute: '/level',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/level':
              return MaterialPageRoute(
                builder: (context) => LevelPage(level: level),
              );
            case '/next':
              return MaterialPageRoute(
                builder: (context) => RecursiveNavigator(level: level + 1),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => LevelPage(level: level),
              );
          }
        },
      ),
    );
  }
}

class LevelPage extends StatelessWidget {
  final int level;

  const LevelPage({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Você está no nível $level'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/next');
            },
            child: const Text('Ir para o próximo nível'),
          ),
          if (level > 1)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Volta para o nível anterior
              },
              child: const Text('Voltar para o nível anterior'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed('/route2');
            },
            child: const Text('Voltar ao nível principal'),
          ),
        ],
      ),
    );
  }
}
