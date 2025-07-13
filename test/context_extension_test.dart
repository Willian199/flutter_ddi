import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'mocks/test_mocks.dart';

void main() {
  group('FlutterDDIContext Extension Tests', () {
    testWidgets('should get dependency from context',
        (WidgetTester tester) async {
      // Register a test dependency
      ddi.singleton<MockTestService>(() => MockTestService());

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.get<MockTestService>();
              return Text(service.message);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello from MockTestService'), findsOneWidget);

      ddi.destroy<MockTestService>();
    });

    testWidgets('should get dependency with qualifier',
        (WidgetTester tester) async {
      const qualifier = 'custom_service';
      ddi.singleton<MockTestService>(() => MockTestService(),
          qualifier: qualifier);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.get<MockTestService>(qualifier);
              return Text(service.message);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello from MockTestService'), findsOneWidget);

      ddi.destroy<MockTestService>();
    });

    testWidgets('should throw error when dependency not found',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              try {
                context.get<MockTestService>();
                return const Text('Should not reach here');
              } catch (e) {
                return Text('Error: ${e.toString()}');
              }
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('Error:'), findsOneWidget);
    });

    testWidgets('should get optional dependency when registered',
        (WidgetTester tester) async {
      ddi.singleton<MockTestService>(() => MockTestService());

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.getOptional<MockTestService>();
              return Text(service?.message ?? 'No service');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello from MockTestService'), findsOneWidget);

      ddi.destroy<MockTestService>();
    });

    testWidgets('should return null when optional dependency not found',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.getOptional<MockTestService>();
              return Text(service?.message ?? 'No service');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No service'), findsOneWidget);
    });

    testWidgets('should get optional dependency with qualifier',
        (WidgetTester tester) async {
      const qualifier = 'optional_service';
      ddi.singleton<MockTestService>(() => MockTestService(),
          qualifier: qualifier);

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.getOptional<MockTestService>(qualifier);
              return Text(service?.message ?? 'No service');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello from MockTestService'), findsOneWidget);

      ddi.destroy(qualifier: qualifier);
    });

    testWidgets('should get route arguments from context',
        (WidgetTester tester) async {
      final testArgs = {'key': 'value', 'number': 42};

      await tester.pumpWidget(
        MaterialApp(
          routes: {
            '/test': (context) => Builder(
                  builder: (context) {
                    final args = context.arguments<Map<String, dynamic>>();
                    return Text(args?['key']?.toString() ?? 'no args');
                  },
                ),
          },
          home: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => Builder(
                  builder: (context) {
                    final args = context.arguments<Map<String, dynamic>>();
                    return Text(args?['key']?.toString() ?? 'no args');
                  },
                ),
                settings: RouteSettings(
                  name: '/test',
                  arguments: testArgs,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('value'), findsOneWidget);
    });

    testWidgets('should handle null route arguments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => Builder(
                  builder: (context) {
                    final args = context.arguments<Map<String, dynamic>>();
                    return Text(args?.toString() ?? 'null args');
                  },
                ),
                settings: const RouteSettings(
                  name: '/test',
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('null args'), findsOneWidget);
    });

    testWidgets('should get typed route arguments',
        (WidgetTester tester) async {
      const testString = 'test_string_arg';

      await tester.pumpWidget(
        MaterialApp(
          home: Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => Builder(
                  builder: (context) {
                    final args = context.arguments<String>();
                    return Text(args ?? 'no string args');
                  },
                ),
                settings: const RouteSettings(
                  name: '/test',
                  arguments: testString,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('test_string_arg'), findsOneWidget);
    });

    testWidgets('should get optional dependency with parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.getOptionalWith<MockTestService, String>(
                parameter: 'test_param',
              );
              return Text(service?.message ?? 'No service with param');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No service with param'), findsOneWidget);
    });

    testWidgets('should work with multiple dependencies',
        (WidgetTester tester) async {
      ddi.dependent<MockTestService>(() => MockTestService());
      ddi.application<MockTestModule>(() => MockTestModule());

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.get<MockTestService>();
              final module = context.get<MockTestModule>();
              return Column(
                children: [
                  Text(service.message),
                  Text(module.toString()),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello from MockTestService'), findsOneWidget);
      expect(find.text('MockTestModule(default)'), findsOneWidget);

      ddi.destroy<MockTestService>();
      ddi.destroy<MockTestModule>();
    });

    testWidgets('should handle dependency lifecycle',
        (WidgetTester tester) async {
      ddi.singleton<MockTestService>(() => MockTestService());

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final service = context.get<MockTestService>();
              service.increment();
              return Text('Counter: ${service.counter}');
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Counter: 1'), findsOneWidget);

      ddi.destroy<MockTestService>();
    });
  });
}
