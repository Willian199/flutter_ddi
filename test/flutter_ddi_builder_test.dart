import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'mocks/test_mocks.dart';

void main() {
  group('FlutterDDIBuilder Tests', () {
    testWidgets('should register module successfully',
        (WidgetTester tester) async {
      bool moduleRegistered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () {
              moduleRegistered = true;
              return MockTestModule();
            },
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(moduleRegistered, isTrue);
      expect(ddi.isRegistered<MockTestModule>(), isTrue);
    });

    testWidgets('should register module with custom qualifier',
        (WidgetTester tester) async {
      const qualifier = 'custom_qualifier';

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(name: 'custom'),
            moduleName: qualifier,
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(ddi.isRegistered<MockTestModule>(qualifier: qualifier), isTrue);
    });

    testWidgets('should dispose module when widget is disposed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(ddi.isRegistered<MockTestModule>(), isTrue);

      // Dispose widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));
      await tester.pumpAndSettle();

      expect(ddi.isRegistered<MockTestModule>(), isFalse);
    });

    testWidgets('should show default loading indicator initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      // Should show loading initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should show custom loading widget',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            loading: const Text('Custom Loading'),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      expect(find.text('Custom Loading'), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should show child after loading completes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should show default error widget on initialization failure',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockErrorModule>(
            module: () => MockErrorModule(),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Exception: MockErrorModule initialization failed'),
          findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should show custom error widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockErrorModule>(
            module: () => MockErrorModule(),
            error: const Text('Custom Error'),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Custom Error'), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets('should show error widget with error message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockErrorModule>(
            module: () => MockErrorModule(),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.textContaining('MockErrorModule initialization failed'),
          findsOneWidget);
    });

    testWidgets('should handle multiple module registrations',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              FlutterDDIBuilder<MockTestModule>(
                module: () => MockTestModule(name: 'module1'),
                child: (context) => const Text('Module 1'),
              ),
              FlutterDDIBuilder<MockTestModule>(
                module: () => MockTestModule(name: 'module2'),
                moduleName: 'module2',
                child: (context) => const Text('Module 2'),
              ),
            ],
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(ddi.isRegistered<MockTestModule>(), isTrue);
      expect(ddi.isRegistered<MockTestModule>(qualifier: 'module2'), isTrue);
    });

    testWidgets('should handle rapid widget rebuilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) => const Text('Test'),
          ),
        ),
      );

      // Rapid rebuilds
      await tester.pump();
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
      expect(ddi.isRegistered<MockTestModule>(), isTrue);
    });

    testWidgets('should work with MaterialApp navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) => Scaffold(
              appBar: AppBar(title: const Text('Test')),
              body: const Text('Test Body'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Test'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('should handle context extensions',
        (WidgetTester tester) async {
      // Register a service
      ddi.singleton<MockTestService>(() => MockTestService());

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) {
              final service = context.get<MockTestService>();
              return Text(service.message);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Hello from MockTestService'), findsOneWidget);
    });
  });
}
