// First Sub-Screen
import 'package:example/model/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class DetailsScreen extends StatelessWidget with DDIController<Detail> {
  DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(controller.message),
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
