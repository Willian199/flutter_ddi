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

### FlutterDDIModuleRouter
The `FlutterDDIModuleRouter` class is an abstraction that allows defining a module to organize and encapsulate specific dependencies. It simplifies modular navigation and decouples dependency registration.

`interceptors:` This property allows you to define a list of `ModuleInterceptor` instances that can intercept and handle operations during the module's creation. By default, it returns an empty list but can be extended to handle custom logic, such as logging, security, or validation tasks.

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

## Simplified Flutter Integration

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

# Known Limitation

`Circular Routes:` At present, the package does not fully support circular route structures. Defining circular dependencies between routes will lead to errors during the module registration process.


Any help, suggestions, corrections are welcome.
