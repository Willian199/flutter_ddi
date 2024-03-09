// Second Screen
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final message = context.get<String>('second_sub');

    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
