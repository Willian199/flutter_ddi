import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import '../mocks/test_mocks.dart';

void main() {
  group('Widget Scope Integration Tests', () {
    testWidgets('should use widget scope in Flutter widget tree',
        (WidgetTester tester) async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final widget1 = ddi.get<MockTestWidget>();
              final widget2 = ddi.get<MockTestWidget>();

              return Column(
                children: [
                  widget1,
                  widget2,
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('MockWidget'), findsNWidgets(2));

      await ddi.destroy<MockTestWidget>();
    });

    testWidgets('should create fresh instances on each build',
        (WidgetTester tester) async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      MockTestWidget? previousInstance;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              final instance = ddi.get<MockTestWidget>();

              // First build
              if (previousInstance == null) {
                previousInstance = instance;
              } else {
                // On rebuild, should be a new instance
                expect(instance, isNot(same(previousInstance)));
              }

              return instance;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Rebuild
      await tester.pump();

      await ddi.destroy<MockTestWidget>();
    });

    testWidgets('should work with PostConstruct in widget tree',
        (WidgetTester tester) async {
      await ddi.widget<MockPostConstructWidget2>(MockPostConstructWidget2.new);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final widget = ddi.get<MockPostConstructWidget2>();
              return widget;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Initialized: true'), findsOneWidget);

      await ddi.destroy<MockPostConstructWidget2>();
    });
  });
}
