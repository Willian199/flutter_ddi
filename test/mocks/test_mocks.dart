// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

/// Mock service for testing dependency injection
class MockTestService {
  String get message => 'Hello from MockTestService';

  int _counter = 0;
  int get counter => _counter;

  void increment() {
    _counter++;
  }
}

/// Mock module for testing FlutterDDIBuilder
class MockTestModule {
  MockTestModule({this.name = 'default'});
  final String name;

  @override
  String toString() => 'MockTestModule($name)';
}

/// Mock module that throws an error during initialization
class MockErrorModule {
  MockErrorModule() {
    throw Exception('MockErrorModule initialization failed');
  }
}

/// Mock ChangeNotifier for testing ListenableState
class MockTestChangeNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

/// Mock page for testing FlutterDDIPage
class MockTestPage extends FlutterDDIPage {
  @override
  String get path => '/mock-test';

  @override
  WidgetBuilder get page => (_) => const Text('Mock Test Page');
}

/// Mock router for testing FlutterDDIRouter
class MockTestRouter extends FlutterDDIRouter {
  @override
  String get path => '/mock-router';

  @override
  WidgetBuilder get page => (_) => const Text('Mock Router Page');

  @override
  List<FlutterDDIModuleDefine> get modules => [
        MockSubModule1(),
        MockSubModule2(),
      ];
}

/// Mock sub-module 1
class MockSubModule1 extends FlutterDDIPage {
  @override
  String get path => '/sub1';

  @override
  WidgetBuilder get page => (_) => const Text('Mock Sub Module 1');
}

/// Mock sub-module 2
class MockSubModule2 extends FlutterDDIPage {
  @override
  String get path => '/sub2';

  @override
  WidgetBuilder get page => (_) => const Text('Mock Sub Module 2');
}

/// Mock outlet module for testing FlutterDDIOutletModule
class MockOutletModule extends FlutterDDIOutletModule {
  @override
  String get path => '/mock-outlet';

  @override
  WidgetBuilder get page => (_) => const Text('Mock Outlet Module');

  @override
  List<FlutterDDIModuleDefine> get modules => [
        MockSubModule1(),
        MockSubModule2(),
      ];
}

/// Mock error module interface implementation
class MockErrorModuleInterface extends ErrorModuleInterface {
  const MockErrorModuleInterface(super.snapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Text('Mock Error: ${snapshot.error}'),
      ),
    );
  }
}

/// Mock loader module interface implementation
class MockLoaderModuleInterface extends LoaderModuleInterface {
  const MockLoaderModuleInterface();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Mock widget that uses ListenableState
class MockListenableWidget extends StatefulWidget {
  const MockListenableWidget({super.key});

  @override
  State<MockListenableWidget> createState() => MockListenableWidgetState();
}

class MockListenableWidgetState
    extends ListenableState<MockListenableWidget, MockTestChangeNotifier> {
  @override
  Widget build(BuildContext context) {
    return Text('Count: ${listenable.count}');
  }

  void increment() {
    listenable.increment();
  }

  void decrement() {
    listenable.decrement();
  }

  void reset() {
    listenable.reset();
  }
}

/// Mock widget that uses context extensions
class MockContextExtensionWidget extends StatelessWidget {
  const MockContextExtensionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.get<MockTestService>();
    final args = context.arguments<Map<String, dynamic>>();

    return Column(
      children: [
        Text(service.message),
        Text('Args: ${args?['key'] ?? 'no args'}'),
      ],
    );
  }
}

/// Mock widget for testing FlutterDDIBuilder
class MockDDIBuilderWidget extends StatelessWidget {
  const MockDDIBuilderWidget({
    required this.moduleFactory,
    super.key,
    this.moduleName,
    this.error,
    this.loading,
  });
  final MockTestModule Function() moduleFactory;
  final String? moduleName;
  final Widget? error;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return FlutterDDIBuilder<MockTestModule>(
      module: moduleFactory,
      moduleName: moduleName,
      error: error,
      loading: loading,
      child: (context) => const Text('DDI Builder Child'),
    );
  }
}

// Custom router for testing error and loading widgets
class CustomErrorLoadingRouter extends FlutterDDIRouter {
  @override
  String get path => '/custom-router';

  @override
  WidgetBuilder get page => (_) => const Text('Custom Router Page');

  @override
  List<FlutterDDIModuleDefine> get modules => [];

  @override
  Widget? get error => const Text('Custom Error');

  @override
  Widget? get loading => const Text('Custom Loading');
}

/// Mock Widget for testing Widget Scope
class MockTestWidget extends StatelessWidget {
  const MockTestWidget({super.key, this.name, this.value});
  final String? name;
  final int? value;

  @override
  Widget build(BuildContext context) {
    return Text('MockWidget: ${name ?? 'default'} - ${value ?? 0}');
  }
}

/// Mock Widget with PostConstruct that works properly
class MockPostConstructWidget2 extends StatelessWidget with PostConstruct {
  MockPostConstructWidget2({super.key});
  bool _initialized = false;
  bool get initialized => _initialized;

  @override
  void onPostConstruct() {
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Text('Initialized: $_initialized');
  }
}

class MockPostConstructCount extends StatelessWidget with PostConstruct {
  MockPostConstructCount({super.key});
  bool _initialized = false;
  bool get initialized => _initialized;
  int contador = 0;

  @override
  void onPostConstruct() {
    _initialized = true;
    contador++;
  }

  @override
  Widget build(BuildContext context) {
    return Text('Initialized: $_initialized');
  }
}

/// Mock Widget with constructor parameter
class MockParamWidget extends StatelessWidget {
  const MockParamWidget({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(message);
  }
}

/// Mock Widget that implements DDIModule
// Note: StatelessWidget is immutable, so we can't test moduleQualifier properly
// This is a limitation - DDIModule should be used with regular classes, not Widgets
class MockModuleWidget extends StatelessWidget {
  const MockModuleWidget({super.key, this.qualifier});
  final Object? qualifier;

  @override
  Widget build(BuildContext context) {
    return Text('Module: ${qualifier ?? MockModuleWidget}');
  }
}

/// Mock Widget for testing canDestroy: false scenarios (Direct Registration)
class MockIndestructibleWidget extends StatelessWidget {
  const MockIndestructibleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Indestructible Widget');
  }
}

/// Mock Widget for testing canDestroy: false scenarios (asWidget extension)
class MockIndestructibleWidget2 extends StatelessWidget {
  const MockIndestructibleWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Indestructible Widget 2');
  }
}

/// Mock Widget for testing canDestroy: false scenarios (widget extension)
class MockIndestructibleWidget3 extends StatelessWidget {
  const MockIndestructibleWidget3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Indestructible Widget 3');
  }
}

/// Mock Widget with PostConstruct for testing canDestroy: false
class MockIndestructiblePostConstructWidget extends StatelessWidget
    with PostConstruct {
  MockIndestructiblePostConstructWidget({super.key});
  bool _initialized = false;
  bool get initialized => _initialized;

  @override
  void onPostConstruct() {
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    return Text('Indestructible Initialized: $_initialized');
  }
}

/// Mock Widget with parameter for testing canDestroy: false
class MockIndestructibleParamWidget extends StatelessWidget {
  const MockIndestructibleParamWidget({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Text('Indestructible: $message');
  }
}
