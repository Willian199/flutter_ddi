# Flutter DDI Library

[![pub package](https://img.shields.io/pub/v/dart_ddi.svg?logo=dart&logoColor=00b9fc)](https://pub.dartlang.org/packages/dart_ddi)
[![CI](https://img.shields.io/github/actions/workflow/status/Willian199/dart_ddi/dart.yml?branch=master&logo=github-actions&logoColor=white)](https://github.com/Willian199/dart_ddi/actions)
[![Last Commits](https://img.shields.io/github/last-commit/Willian199/dart_ddi?logo=git&logoColor=white)](https://github.com/Willian199/dart_ddi/commits/master)
[![Issues](https://img.shields.io/github/issues/Willian199/dart_ddi?logo=github&logoColor=white)](https://github.com/Willian199/dart_ddi/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/Willian199/dart_ddi?logo=github&logoColor=white)](https://github.com/Willian199/dart_ddi/pulls)
[![Code size](https://img.shields.io/github/languages/code-size/Willian199/dart_ddi?logo=github&logoColor=white)](https://github.com/Willian199/dart_ddi)
[![License](https://img.shields.io/github/license/Willian199/dart_ddi?logo=open-source-initiative&logoColor=green)](https://github.com/Willian199/dart_ddi/blob/master/LICENSE)

The `flutter_ddi` library is a Flutter package that integrates with the [`dart_ddi`](https://pub.dev/packages/dart_ddi) dependency injection manager, simplifying the dependency injection process in Flutter applications. It enhances code organization, flexibility, and maintainability, making the codebase more structured and scalable.

## Features

The `flutter_ddi` offers a range of features that can be easily integrated into your Flutter application. You can choose to use or not the route management provided by the package. If preferred, you can integrate `flutter_ddi` solely for dependency injection, maintaining your own route logic.

- **Integration during navigation**: While navigating between screens, you can utilize `flutter_ddi` without the need to create routes. The package simplifies passing dependencies to new screens.

- **Enhanced route building**: By using `flutter_ddi` to construct your routes, you improve code organization by separating navigation logic from object creation logic.

- **Improved code organization**: By separating navigation and dependency structures from screen and business logics, your code becomes more organized and easier to maintain, especially in large and complex projects.

- **Flexibility and scalability**: This package is designed to be flexible and scalable, allowing you to add and change dependencies as needed without impact on other parts of the code.

## Using flutter_ddi

## Defining Modules and Routes

### FlutterDDIModule
The `FlutterDDIModule` class is an abstraction that allows defining a module to organize and encapsulate specific dependencies.

Example Usage:

```dart
class HomeModule extends FlutterDDIModule {

  @override
  FutureOr<void> onPostConstruct() {
    registerApplication<HomeRepository>(() => HomeRepositoryImpl());
    registerApplication<HomeService>(() => HomeServiceImpl(homeRepository: ddi()));
    registerApplication<HomeController>(() => HomeControllerHomeServiceImpl(homeService: ddi<HomeService>()));
  }

  @override
  WidgetBuilder get page => (_) => const HomePage();

  @override
  String get path => '/home';
}
```

### FlutterDDIModuleRouter
The `FlutterDDIModuleRouter` class is used to define routes that contain modules. With it, you can organize the application navigation in a modular way, facilitating code maintenance and expansion.

Example Usage:

```dart
class SplashModule extends FlutterDDIModuleRouter {

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

You can also use the `DDIModule` mixin in a class that extends `FlutterDDIModuleRouter`. This allows creating a structure of modules with submodules.

Example Usage:

```dart
class SplashModule extends FlutterDDIModuleRouter with DDIModule {

  @override
  FutureOr<void> onPostConstruct() {
    registerSingleton<DioForNative>(() => RestClient('http://my-url'));
  }

  @override
  WidgetBuilder get page => (_) => const SplashPage();

  @override
  String get path => '/';

  @override
  List<FlutterDDIModuleDefine> get modules => [
    FlutterDDIPage.from(path: 'signup', page: (_) => const SignupPage()),
    LoginModule(),
    HomeModule(),
  ];
}
```

### FlutterDDIFutureModuleRouter
The `FlutterDDIFutureModuleRouter` class is used to create modules that have `Future` loading. Making it possible to `await` for initialization before accessing the route

Example Usage:

```dart
class SplashModule extends FlutterDDIFutureModuleRouter {

  @override
  Future<void> onPostConstruct() async{
    await registerSingleton<Databaseconnection>(() async => Databaseconnection());
  }

  @override
  WidgetBuilder get page => (_) => const SplashPage();

  @override
  String get path => '/';

  @override
  List<FlutterDDIModuleDefine> get modules => [
    FlutterDDIPage.from(path: 'signup', page: (_) => const SignupPage()),
    LoginModule(),
    HomeModule(),
  ];

  @override
  Widget get error => const SizedBox.shrink();

  @override
  Widget get loading => const Center(child: CircularProgressIndicator());

}
```

### FlutterDDIPage
The `FlutterDDIPage` class allows defining pages that do not have any dependencies.

Example Usage:

```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Home Page Content'),
      ),
    );
  }
}

class HomeModule extends FlutterDDIPage {
  @override
  WidgetBuilder get page => (_) => const HomePage();

  @override
  String get path => '/home';
}
```

## Using the FlutterDDIRouter

The `FlutterDDIRouter` class is a utility that allows building application routes from the defined modules and pages. With it, you can get a map of routes ready to be used with the Flutter Navigator.

Example Usage:

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: FlutterDDIRouter.getRoutes(
        modules: [
            SplashModule(),
        ],
      ),
    );
  }
}
```

## Simplified State Management

Managing state in Flutter applications, especially for medium or smaller projects, doesn't always require complex state management solutions. For apps where simplicity and efficiency are key, using these mixins and classes for state management can be a straightforward and effective approach. But for larger and complex projects, it's recommended to use a proper state management solutions.

### How It Works
Under the hood, these mixins and classes utilize the `setState` method to update the widget's state. They handle registering an event or stream in the `initState` and cleaning up in the `dispose` method.

#### Example Usage:

```dart
    class HomePage extends StatefulWidget {
        const HomePage({super.key});

        @override
        State<HomePage> createState() => _HomePageState();
    }

    /// You can extend `StreamListenerState` or `EventListenerState`
    class _HomePageState extends StreamListenerState<HomePage, HomePageModel> {
    // class _HomePageState extends EventListenerState<HomePage, HomePageModel> {

      Widget build(BuildContext context) {
          return Text('Welcome ${state.name} ${state.surname}');
      } 
    }
```

```dart
    class HomePage extends StatefulWidget {
        const HomePage({super.key});

        @override
        State<HomePage> createState() => _HomePageState();
    }

    /// You can use the mixin `StreamListener` or `EventListener`
    class _HomePageState extends State<HomePage> with StreamListener<HomePage, HomePageModel> {
    // class _HomePageState extends State<HomePage> with EventListener<HomePage, HomePageModel> {

      Widget build(BuildContext context) {
          return Text('Welcome ${state.name} ${state.surname}');
      }
      
    }
```

### FlutterDDIWidget e FlutterDDIFutureWidget

These two widgets handle dependency injection seamlessly. The `FlutterDDIWidget` handles dependency injection by wrapping a child widget and registering its module. Similarly, the `FlutterDDIFutureWidget` handles dependency injection by wrapping a future builder and registering its module asynchronously.

Example Usage:

```dart
    class HomePage extends StatelessWidget {
        const HomePage({super.key});

        @override
        Widget build(BuildContext context) {
            return Column(
                children: [
                    FlutterDDIWidget<BeanT>(
                      module: WidgetModule.new,
                      child: const MyWidget(),
                      moduleName: 'WidgetModule',
                    ),
                    FlutterDDIFutureWidget<BeanT>(
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



Any help, suggestions, corrections are welcome.
