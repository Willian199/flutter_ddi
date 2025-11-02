// Second Screen
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({super.key})
      : message = ddi.get<String>(qualifier: 'second_sub');

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text('From Constructor: $message'),
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
