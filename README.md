# Flutter DDI Library

[![pub package](https://img.shields.io/pub/v/flutter_ddi.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/flutter_ddi)
[![Last Commits](https://img.shields.io/github/last-commit/Willian199/flutter_ddi?logo=git&logoColor=white)](https://github.com/Willian199/flutter_ddi/commits/master)
[![Issues](https://img.shields.io/github/issues/Willian199/flutter_ddi?logo=github&logoColor=white)](https://github.com/Willian199/flutter_ddi/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/Willian199/flutter_ddi?logo=github&logoColor=white)](https://github.com/Willian199/flutter_ddi/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/Willian199/flutter_ddi?logo=github&logoColor=white)](https://github.com/Willian199/flutter_ddi)
[![License](https://img.shields.io/github/license/Willian199/flutter_ddi?logo=open-source-initiative&logoColor=green)](https://github.com/Willian199/flutter_ddi/blob/master/LICENSE)

The `flutter_ddi` library is a Flutter package that integrates with the [`dart_ddi`](https://pub.dev/packages/dart_ddi) dependency injection manager, simplifying the dependency injection process in Flutter applications. It enhances code organization, flexibility, and maintainability, making the codebase more structured and scalable.

## Features

The `flutter_ddi` offers a range of features that can be easily integrated into your Flutter application. You can choose to use or not the route management provided by the package. If preferred, you can integrate `flutter_ddi` solely for dependency injection, maintaining your own route logic.

- **Integration during navigation**: While navigating between screens, you can utilize `flutter_ddi` without the need to create routes. The package simplifies passing dependencies to new screens.

- **Enhanced route building**: By using `flutter_ddi` to construct your routes, you improve code organization by separating navigation logic from object creation logic.

- **Improved code organization**: By separating navigation and dependency structures from screen and business logics, your code becomes more organized and easier to maintain, especially in large and complex projects.

- **Flexibility and scalability**: This package is designed to be flexible and scalable, allowing you to add and change dependencies as needed without impact on other parts of the code.

## Defining Modules and Routes

### Compile-time environment modules

For boolean feature flags that should support tree shaking, use
`DDIEnvironmentModule` with `bool.fromEnvironment`:

```dart
class AnalyticsModule extends DDIEnvironmentModule {
  AnalyticsModule()
      : super(enabled: const bool.fromEnvironment('ENABLE_ANALYTICS'));

  @override
  Future<void> onEnabled() => singleton<Analytics>(Analytics.new);
}
```

Pass the value at build time:

```shell
flutter build apk --dart-define=ENABLE_ANALYTICS=true
```

This is a compile-time flag, rather than a `.env` file loaded at runtime.
Keep the module constructor and the `bool.fromEnvironment` expression
compile-time constant so disabled registrations can be removed by the compiler.

### FlutterDDIModuleRouter
The `FlutterDDIModuleRouter` class is an abstraction that allows defining a module to organize and encapsulate specific dependencies. It simplifies modular navigation and decouples dependency registration.

`interceptors:` This property allows you to define a list of `ModuleInterceptor` instances that can intercept and handle operations during the module's creation. By default, it returns an empty list but can be extended to handle custom logic, such as logging, security, or validation tasks.

#### Qualifiers and Context

- `FlutterDDIModuleRouter` uses `routeQualifier` as the module qualifier. Because it
  implements `DDIModule`, its `moduleQualifier` is used as the qualifier of a
  dedicated DDI context for the module's dependencies. Dependencies registered
  by the module are therefore isolated from sibling modules, while normal DDI
  lookup still allows access to shared/root dependencies when appropriate.

#### Example Usage:

```dart
class HomeModule extends FlutterDDIModuleRouter {

  @override
  FutureOr<void> onPostConstruct() {
    registerApplication<HomeRepository>(HomeRepositoryImpl.new);
    registerApplication<HomeService>(() => HomeServiceImpl(homeRepository: ddi()));
    registerApplication<HomeController>(() => HomeControllerImpl(homeService: ddi<HomeService>()));
  }

  @override
  WidgetBuilder get page => (_) => const HomePage();

  @override
  String get path => '/home';

  @override
  List<ModuleInterceptor> get interceptors => [
    ModuleInterceptor.of(factory: AuthInterceptor.new.builder.asApplication()),
    ModuleInterceptor<CountryInterceptor>.from(),
  ];
}
```

### FlutterDDIRouter
The `FlutterDDIRouter` class is used to define routes that contain modules. With it, you can organize the application navigation in a modular way, facilitating code maintenance and expansion.

Example Usage:

```dart
class SplashModule extends FlutterDDIRouter {

  @override
  WidgetBuilder get page => (_) => const SplashPage();

  @override
  String get path => '/';

  @override
  List<FlutterDDIModuleDefine> get modules => [
    FlutterDDIPage.from(path: '/signup', page: (_) => const SignupPage()),
    LoginModule(),
    HomeModule(),
  ];
}
```

### FlutterDDIPage
The `FlutterDDIPage` class allows defining pages that do not have any dependencies.

Example Usage:

```dart
class HomeModule extends FlutterDDIPage {
  @override
  WidgetBuilder get page => (_) => const HomePage();

  @override
  String get path => '/home';
}
```

## Creating Routes

To define routes for your application, you need to create a class that extends `FlutterDDIRouter`. This allows you to organize the application's navigation by combining modules and pages. With this approach, you can easily generate a map of routes ready to be used with the Flutter Navigator.

### Example Usage:

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late final SplashModule _splashModule = SplashModule();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: _splashModule.getRoutes(), // Retrieves the routes from the SplashModule
    );
  }
}
```

### FlutterDDIBuilder

The Widget `FlutterDDIBuilder` handles dependency injection by wrapping a builder and registering its module asynchronously.

Example Usage:

```dart
    class HomePage extends StatelessWidget {
        const HomePage({super.key});

        @override
        Widget build(BuildContext context) {
            return Column(
                children: [
                    FlutterDDIBuilder<AsyncWidgetModule>(
                      module: AsyncWidgetModule.new,
                      child: (context) => const MyWidget(),
                      moduleName: 'AsyncWidgetModule',
                      loading: const CircularProgressIndicator(),
                      error: const ErrorWidget(),
                    ),
                ],
            );
        } 
    }
```

## Extension FlutterDDIContext
The `FlutterDDIContext` extension provides a `get` and `arguments` method on the `BuildContext` class. 
The `get` method allows getting a dependency from the context. 
The `arguments` method allows getting the arguments passed in the route.

Example Usage:

```dart
    class HomePage extends StatelessWidget {
        const HomePage({super.key});

        @override
        Widget build(BuildContext context) {
            final HomePageController controller = context.get<HomePageController>();

            final RouteArguments routeData = context.arguments<RouteArguments>();

            return Container();
        }
    }
```

## Simplified Listener Integration

The `ListenableState` class and `ListenableMixin` simplify the use of `ValueNotifier` and `ChangeNotifier` in Flutter applications. These utilities provide a way to integrate Listenable objects into StatefulWidget with less code.

### How It Works

`ListenableState` and `ListenableMixin` automatically register and unregister listeners in initState and dispose, ensuring efficient state handling. This approach eliminates the need for explicit listener management, reducing boilerplate code and improving maintainability.

Example Usage:

```dart	
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Uses ListenableState to bind with a ChangeNotifier or ValueNotifier.
class _HomePageState extends ListenableState<HomePage, HomePageModel> {
  @override
  Widget build(BuildContext context) {
    return Text('Welcome ${listenable.name} ${listenable.surname}');
  }
}

/// Example model implementing ChangeNotifier.
class HomePageModel extends ChangeNotifier {
  String _name = 'John';
  String _surname = 'Wick';

  String get name => _name;
  String get surname => _surname;

  void update(String name, String surname) {
    _name = name;
    _surname = surname;
    notifyListeners();
  }
}
```

## Command and Effect Pattern

The `Command` and `Effect` classes provide a lightweight one-way communication channel based on actions and effects. This pattern allows creating a **unique link** between who triggers an action (`TAction`) and who produces an effect (`TEffect`).

### Concept

- **Executor (handler)**: Registers the function that processes the action via `on()`
- **Emitter**: Triggers the execution via `execute()` and receives the result of the effect returned by the handler

### Features

- Supports synchronous or asynchronous execution (`FutureOr<TEffect?>`)
- Allows redefining or clearing the handler with `clear()`
- Generic types allow reuse for any action and effect
- Semantic aliases: `Command` (for emitters) and `Effect` (for executors)

### Usage Example

```dart
// Definition of a command with return effect
final Command<String, int> lengthCommand = Command();

// Executor registers the command behavior
lengthCommand.on((input) {
  if (input == null) return 0;
  return input.length;
});

// Emitter triggers execution and receives effect
final result = lengthCommand.execute('Hello');
print(result); // 5

// Clears the handler, if necessary
lengthCommand.clear();
```

### Notes

- If the handler is not registered before execution, `execute()` throws an `AssertionError`
- `TAction` is optional (`null`) in the current implementation
- Only one handler can be registered per command/effect link

## ReactiveCommand and ReactiveEffect Pattern

The `ReactiveCommand` and `ReactiveEffect` classes are reactive variations of `Command` and `Effect` that combine the command/effect pattern with Flutter's reactive system using `ValueNotifier`.

### Concept

- **Executor (handler)**: Registers the function that processes the action via `on()`
- **Emitter**: Triggers the execution via `execute()` and notifies listeners automatically
- **Observers**: Can listen to effect changes via `addListener()` or use Flutter widgets that listen to `ValueNotifier`

### Features

- Supports synchronous or asynchronous execution (`FutureOr<TEffect?>`)
- Automatically notifies listeners when effects change
- Extends `ValueNotifier`, making it compatible with Flutter's reactive system
- Can be used with widgets like `ValueListenableBuilder`
- Allows redefining or clearing the handler with `clear()`
- Semantic aliases: `ReactiveCommand` (for emitters) and `ReactiveEffect` (for executors)

### Usage Example

```dart
// Definition of a reactive command
final ReactiveCommand<String, int> lengthCommand = ReactiveCommand();

// Executor registers the command behavior
lengthCommand.on((input) {
  if (input == null) return 0;
  return input.length;
});

// Listen to changes in the effect
lengthCommand.addListener(() {
  print('New effect: ${lengthCommand.value}');
});

// Emitter triggers execution (automatically notifies listeners)
await lengthCommand.execute('Hello');
// Prints: "New effect: 5"

// Access current effect value
print(lengthCommand.value); // 5
```

### Usage with Flutter Widgets

```dart
// In a widget using ValueListenableBuilder
ValueListenableBuilder<int?>(
  valueListenable: lengthCommand,
  builder: (context, value, child) {
    return Text('Length: ${value ?? 0}');
  },
)
```

### Notes

- If the handler is not registered before execution, `execute()` throws an `AssertionError`
- The initial value is `null` until the first execution
- When asynchronous handlers are used, listeners are notified after the `Future` completes
- Disposing this command will also dispose the internal `ValueNotifier`

## Widget Scope

The Widget Scope is a specialized scope designed specifically for Flutter Widgets. It creates a new instance every time it is requested, making it ideal for Widgets that need clean instances on each build.

### Characteristics

- **Creates a new instance every time it is requested** - Each `get` call returns a fresh instance
- **Does not support Interceptors** - Interceptors are not applied to Widget Scope instances
- **Does not support Decorators** - Decorators cannot be used with Widget Scope
- **Does not support Children (child modules)** - Child module relationships are not supported
- **Supports PostConstruct** - PostConstruct lifecycle hook is supported for initialization after creation
- **Does not support PreDispose or PreDestroy** - Since instances are not cached, disposal hooks are not needed

**Note:** This scope does not maintain state, so instances are created and discarded automatically. Since instances are not cached, there is no need to dispose of them.

### Registration Methods

#### Using `asWidget()` Extension

The `asWidget()` extension method is available on `CustomBuilder` for easy registration:

```dart
MyWidget.new.builder.asWidget();

// OR

MyWidget.new.builder.asWidget(
  qualifier: 'myWidget',
  canDestroy: true,
  canRegister: () => true,
  selector: (qualifier) => qualifier == 'myWidget',
);
```

#### Using `widget()` Extension

The `widget()` extension method is available on `DDI` for direct registration:

```dart
ddi.widget<MyWidget>(
  MyWidget.new,
  qualifier: 'myWidget',
  canDestroy: true,
);
```

#### Direct Factory Registration

You can also register directly using the `WidgetFactory`:

```dart
await ddi.register<MyWidget>(
  factory: WidgetFactory<MyWidget>(
    builder: MyWidget.new.builder,
    canDestroy: true,
  ),
  qualifier: 'myWidget',
);
```

### Usage Example

```dart
// Register a Widget with Widget Scope
MyCustomWidget.new.builder.asWidget();

// Use in Widget tree
class ParentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Each call to get() creates a new instance
    final widget1 = ddi.get<MyCustomWidget>();
    final widget2 = ddi.get<MyCustomWidget>();
    
    // widget1 and widget2 are different instances
    return Column(
      children: [
        widget1,
        widget2,
      ],
    );
  }
}
```

# Known Limitation

`Circular Routes:` Nested routes are supported as long as the module graph is
acyclic. DDI contexts isolate each module's dependencies and lifecycle, but do
not change route graph traversal. If a router directly or indirectly contains
itself, `getRoutes()` recursively traverses the cycle and can overflow instead
of producing a route map. Define a tree/DAG of routes and keep shared
dependencies in the root context.


Any help, suggestions, corrections are welcome.
