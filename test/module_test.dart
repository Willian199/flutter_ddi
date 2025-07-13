import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import 'mocks/test_mocks.dart';
import 'package:flutter_ddi/src/exception/null_context_exception.dart';

void main() {
  group('FlutterDDI Module Tests', () {
    test('should create page with correct path', () {
      final page = MockTestPage();
      expect(page.path, equals('/mock-test'));
    });

    test('should create page from factory', () {
      final page = FlutterDDIPage.from(
        path: '/factory-test',
        page: (_) => const Text('Factory Test Page'),
      );
      expect(page.path, equals('/factory-test'));
    });

    test('should throw error for empty path in factory', () {
      expect(
        () => FlutterDDIPage.from(
          path: '',
          page: (_) => const Text('Empty Path'),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    testWidgets('should build page correctly', (WidgetTester tester) async {
      final page = MockTestPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => page.page(context),
          ),
        ),
      );

      expect(find.text('Mock Test Page'), findsOneWidget);
    });

    testWidgets('should handle page without interceptors',
        (WidgetTester tester) async {
      final page = FlutterDDIPage.from(
        path: '/no-interceptor-test',
        page: (_) => const Text('No Interceptor Test Page'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => page.page(context),
          ),
        ),
      );

      expect(find.text('No Interceptor Test Page'), findsOneWidget);
    });

    test('should have default interceptors list', () {
      final page = MockTestPage();
      expect(page.interceptors, isEmpty);
    });

    test('should have correct module qualifier', () {
      final page = MockTestPage();
      expect(page.moduleQualifier, equals(MockTestPage));
    });

    test('should create router with correct path', () {
      final router = MockTestRouter();
      expect(router.path, equals('/mock-router'));
    });

    test('should have modules list', () {
      final router = MockTestRouter();
      expect(router.modules, hasLength(2));
      expect(router.modules[0], isA<MockSubModule1>());
      expect(router.modules[1], isA<MockSubModule2>());
    });

    test('should have default error and loading widgets', () {
      final router = MockTestRouter();
      expect(router.error, isNull);
      expect(router.loading, isNull);
    });

    test('should generate routes correctly', () {
      final router = MockTestRouter();
      final routes = router.getRoutes();

      expect(routes.containsKey('/mock-router'), isTrue);
      expect(routes.containsKey('/mock-router/sub1'), isTrue);
      expect(routes.containsKey('/mock-router/sub2'), isTrue);
    });

    testWidgets('should build router page correctly',
        (WidgetTester tester) async {
      final router = MockTestRouter();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => router.page(context),
          ),
        ),
      );

      expect(find.text('Mock Router Page'), findsOneWidget);
    });

    test('should handle router with custom error and loading widgets', () {
      final router = CustomErrorLoadingRouter();
      expect(router.error, isNotNull);
      expect(router.loading, isNotNull);
    });

    test('should create outlet module with navigator key', () {
      final outlet = MockOutletModule();
      expect(outlet.navigatorKey, isNotNull);
      expect(outlet.navigatorKey.currentState, isNull);
    });

    test('should have correct path', () {
      final outlet = MockOutletModule();
      expect(outlet.path, equals('/mock-outlet'));
    });

    test('should have modules list', () {
      final outlet = MockOutletModule();
      expect(outlet.modules, hasLength(2));
    });

    testWidgets('should build outlet page correctly',
        (WidgetTester tester) async {
      final outlet = MockOutletModule();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => outlet.page(context),
          ),
        ),
      );

      expect(find.text('Mock Outlet Module'), findsOneWidget);
    });

    test('should handle navigation in outlet', () async {
      final outlet = MockOutletModule();

      // Navigation should return null when navigator is not available
      final result = await outlet.navigateTo('/test-route');
      expect(result, isNull);
    });

    testWidgets('should handle module context setting',
        (WidgetTester tester) async {
      final page = MockTestPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              page.context = context;
              return page.page(context);
            },
          ),
        ),
      );

      expect(find.text('Mock Test Page'), findsOneWidget);
      expect(page.context, isNotNull);
    });

    test('should throw exception when context is null', () {
      final page = MockTestPage();
      expect(() => page.context, throwsA(isA<NullContextException>()));
    });

    testWidgets('should handle module destruction',
        (WidgetTester tester) async {
      final page = MockTestPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              page.context = context;
              return page.page(context);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test destruction
      await page.destroy();
    });

    testWidgets('should handle router destruction',
        (WidgetTester tester) async {
      final router = MockTestRouter();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              router.context = context;
              return router.page(context);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Test destruction
      await router.destroy();
    });

    test('should create page with factory method', () {
      final page = FlutterDDIPage.from(
        path: '/factory-path',
        page: (_) => const Text('Factory Page'),
      );

      expect(page.path, equals('/factory-path'));
      expect(page, isA<FlutterDDIPage>());
    });

    // Removido teste com interceptors via factory pois não é compatível com ModuleInterceptor final
    testWidgets('should build factory page correctly',
        (WidgetTester tester) async {
      final page = FlutterDDIPage.from(
        path: '/factory-build-test',
        page: (_) => const Text('Factory Build Test'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => page.page(context),
          ),
        ),
      );

      expect(find.text('Factory Build Test'), findsOneWidget);
    });

    testWidgets('should work with MaterialApp navigation',
        (WidgetTester tester) async {
      final page = MockTestPage();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Test App')),
            body: Builder(
              builder: (context) => page.page(context),
            ),
          ),
        ),
      );

      expect(find.text('Test App'), findsOneWidget);
      expect(find.text('Mock Test Page'), findsOneWidget);
    });

    testWidgets('should handle multiple modules in same app',
        (WidgetTester tester) async {
      final page1 = MockTestPage();
      final page2 = FlutterDDIPage.from(
        path: '/page2',
        page: (_) => const Text('Page 2'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Column(
            children: [
              Builder(builder: (context) => page1.page(context)),
              Builder(builder: (context) => page2.page(context)),
            ],
          ),
        ),
      );

      expect(find.text('Mock Test Page'), findsOneWidget);
      expect(find.text('Page 2'), findsOneWidget);
    });

    testWidgets('should work with FlutterDDIBuilder',
        (WidgetTester tester) async {
      final page = MockTestPage();

      await tester.pumpWidget(
        MaterialApp(
          home: FlutterDDIBuilder<MockTestModule>(
            module: () => MockTestModule(),
            child: (context) => page.page(context),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Mock Test Page'), findsOneWidget);
    });
  });
}
