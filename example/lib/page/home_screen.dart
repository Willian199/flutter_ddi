// Home Screen
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
