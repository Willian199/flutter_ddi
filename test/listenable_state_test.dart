import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'mocks/test_mocks.dart';

void main() {
  group('ListenableState Tests', () {
    testWidgets('should listen to changes and rebuild',
        (WidgetTester tester) async {
      // Register the ChangeNotifier
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Count: 0'), findsOneWidget);

      // Trigger change
      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));
      state.increment();

      await tester.pumpAndSettle();

      expect(find.text('Count: 1'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should handle multiple state changes',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));

      // Multiple increments
      state.increment();
      await tester.pumpAndSettle();
      expect(find.text('Count: 1'), findsOneWidget);

      state.increment();
      await tester.pumpAndSettle();
      expect(find.text('Count: 2'), findsOneWidget);

      state.increment();
      await tester.pumpAndSettle();
      expect(find.text('Count: 3'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should handle decrement operations',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));

      // Increment first
      state.increment();
      await tester.pumpAndSettle();
      expect(find.text('Count: 1'), findsOneWidget);

      // Then decrement
      state.decrement();
      await tester.pumpAndSettle();
      expect(find.text('Count: 0'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should handle reset operations', (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));

      // Increment multiple times
      state.increment();
      state.increment();
      state.increment();
      await tester.pumpAndSettle();
      expect(find.text('Count: 3'), findsOneWidget);

      // Reset
      state.reset();
      await tester.pumpAndSettle();
      expect(find.text('Count: 0'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should properly dispose listeners',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      // Dispose widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpAndSettle();

      // Verify the ChangeNotifier is still registered (it's a singleton)
      expect(ddi.isRegistered<MockTestChangeNotifier>(), isTrue);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should handle widget disposal and recreation',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      // Create first widget
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Count: 0'), findsOneWidget);

      // Dispose and recreate
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Count: 0'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should handle missing ChangeNotifier gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      // Should throw an error when trying to get the ChangeNotifier
      expect(tester.takeException(), isA<Exception>());
    });

    testWidgets('should handle ChangeNotifier disposal',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      // Destroy the ChangeNotifier
      ddi.destroy<MockTestChangeNotifier>();

      // Try to trigger a change
      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));

      // This should not cause an error
      state.increment();
      await tester.pumpAndSettle();
    });

    testWidgets('should handle rapid state changes',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: MockListenableWidget(),
        ),
      );

      await tester.pumpAndSettle();

      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));

      // Rapid state changes
      for (int i = 0; i < 10; i++) {
        state.increment();
      }

      await tester.pumpAndSettle();

      expect(find.text('Count: 10'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should handle multiple widgets with same ChangeNotifier',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        const MaterialApp(
          home: Column(
            children: [
              MockListenableWidget(),
              MockListenableWidget(),
              MockListenableWidget(),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Count: 0'), findsNWidgets(3));

      // Trigger change on one widget
      final state = tester.state<MockListenableWidgetState>(
          find.byType(MockListenableWidget).first);
      state.increment();

      await tester.pumpAndSettle();

      // All widgets should update
      expect(find.text('Count: 1'), findsNWidgets(3));

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should work with FlutterDDIBuilder',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestChangeNotifier>(
            module: () => MockTestChangeNotifier(),
            child: (context) => const MockListenableWidget(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Count: 0'), findsOneWidget);

      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));
      state.increment();

      await tester.pumpAndSettle();

      expect(find.text('Count: 1'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });

    testWidgets('should work with context extensions',
        (WidgetTester tester) async {
      ddi.singleton<MockTestChangeNotifier>(() => MockTestChangeNotifier());

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final notifier = context.get<MockTestChangeNotifier>();
              return Column(
                children: [
                  Text('Direct: ${notifier.count}'),
                  const MockListenableWidget(),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Direct: 0'), findsOneWidget);
      expect(find.text('Count: 0'), findsOneWidget);

      // Trigger change
      final state = tester
          .state<MockListenableWidgetState>(find.byType(MockListenableWidget));
      state.increment();

      await tester.pumpAndSettle();

      expect(find.text('Direct: 0'), findsOneWidget);
      expect(find.text('Count: 1'), findsOneWidget);

      ddi.destroy<MockTestChangeNotifier>();

      expect(ddi.isRegistered<MockTestChangeNotifier>(), isFalse);
    });
  });
}
