// Home Screen
import 'package:example/platform_example_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final platformService = ddi.get<ExamplePlatformService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Implementação selecionada: ${platformService.platform}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/first');
              },
              child: const Text('Go to First Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/second');
              },
              child: const Text('Go to Second Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
