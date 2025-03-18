// Second Screen
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

class SecondScreen extends StatelessWidget {
  SecondScreen({super.key})
      : message = ddi.get<String>(qualifier: 'second_sub');

  // This zoned info only works here, because at this point, the constructor is running in a Zone.
  // But after the constructor is finished, the Zone will be closed.
  // So, currently, this is not recommended to use.
  final String message;

  @override
  Widget build(BuildContext context) {
    final String maybeZonedMessage = ddi.get<String>(qualifier: 'second_sub');
    return Scaffold(
      appBar: AppBar(title: const Text('Second Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [
            Text('From Constructor: $message'),
            Text('From builder: $maybeZonedMessage'),
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
