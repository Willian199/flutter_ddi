import 'package:flutter/material.dart';
import 'package:flutter_ddi/src/widgets/flutter_ddi_custom_pop_scope.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomPopScope', () {
    testWidgets('does not destroy when back is attempted on the last route', (WidgetTester tester) async {
      int destroyCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: CustomPopScope(
            onPopInvoked: () async {
              destroyCount++;
            },
            child: const Text('Home'),
          ),
        ),
      );

      final dynamic popScope = tester.widget(
        find.byWidgetPredicate((Widget widget) => widget is PopScope),
      );

      popScope.onPopInvokedWithResult!(false, null);
      await tester.pumpAndSettle();

      expect(destroyCount, 0);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('destroys when the route already popped', (WidgetTester tester) async {
      int destroyCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: CustomPopScope(
            onPopInvoked: () async {
              destroyCount++;
            },
            child: const Text('Home'),
          ),
        ),
      );

      final dynamic popScope = tester.widget(
        find.byWidgetPredicate((Widget widget) => widget is PopScope),
      );

      popScope.onPopInvokedWithResult!(true, null);
      await tester.pumpAndSettle();

      expect(destroyCount, 1);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('destroys and manually pops when back is blocked but possible', (WidgetTester tester) async {
      int destroyCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: const Text('Home'),
          routes: <String, WidgetBuilder>{
            '/details': (_) => CustomPopScope(
              onPopInvoked: () async {
                destroyCount++;
              },
              child: const Text('Details'),
            ),
          },
        ),
      );

      tester
          .state<NavigatorState>(find.byType(Navigator))
          .pushNamed(
            '/details',
          );
      await tester.pumpAndSettle();

      expect(find.text('Details'), findsOneWidget);

      final dynamic popScope = tester.widget(
        find.byWidgetPredicate((Widget widget) => widget is PopScope),
      );

      popScope.onPopInvokedWithResult!(false, null);
      await tester.pumpAndSettle();

      expect(destroyCount, 1);
      expect(find.text('Details'), findsNothing);
      expect(find.text('Home'), findsOneWidget);
    });
  });
}
