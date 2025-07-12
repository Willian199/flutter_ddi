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
