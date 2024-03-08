# flutter_ddi

The `flutter_ddi` is a package for Flutter that simplifies and enhances integration with `dart_ddi`, a dependency injection manager for Dart. This package is designed to facilitate the dependency injection process in your Flutter application, making it cleaner, organized, and easy to maintain.

## Features

The `flutter_ddi` offers a range of features that can be easily integrated into your Flutter application. You can choose to use or not the route management provided by the package. If preferred, you can integrate `flutter_ddi` solely for dependency injection, maintaining your own route logic.

- **Integration during navigation**: While navigating between screens, you can utilize `flutter_ddi` without the need to create routes. The package simplifies passing dependencies to new screens.

- **Enhanced route building**: By using `flutter_ddi` to construct your routes, you improve code organization by separating navigation logic from object creation logic.

- **Improved code organization**: By separating navigation and dependency structures from screen and business logics, your code becomes more organized and easier to maintain, especially in large and complex projects.

- **Flexibility and scalability**: This package is designed to be flexible and scalable, allowing you to add and change dependencies as needed without impact on other parts of the code.

## Using flutter_ddi

### Defining Modules and Routes

#### `FlutterDDIPage`
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

#### `FlutterDDIModule`
The `FlutterDDIModule` class is an abstraction that allows defining a module to organize and encapsulate specific dependencies.

Example Usage:

```dart
class HomeModule extends FlutterDDIModule {

  @override
  FutureOr<void> onPostConstruct() {
    registerApplication<HomeRepository>(() => HomeRepositoryImpl());
    registerApplication<HomeService>(() => HomeServiceImpl(homeRepository: inject()));
    registerApplication<HomeController>(() => HomeControllerHomeServiceImpl(homeService: inject<HomeService>()));
  }

  @override
  WidgetBuilder get page => (_) => const HomePage();

  @override
  String get path => '/home';
}
```

#### `FlutterDDIModuleRouter`
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

### Using the `FlutterDDIRouter`

#### `FlutterDDIRouter`
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

### Navigation-related Classes

#### `FlutterDDICupertinoPageRoute`
The `FlutterDDICupertinoPageRoute` class is an extension of `CupertinoPageRoute` that allows registering a module for the route.

Example Usage:

```dart
    Navigator.push(
        context,
        FlutterDDICupertinoPageRoute(
            module: () => HomeController(),
            builder: (_) => const HomePage(),
        ),
    );
```

#### `FlutterDDIMaterialPageRoute`
The `FlutterDDIMaterialPageRoute` class is an extension of `MaterialPageRoute` that allows registering a module for the route.

Example Usage:

```dart
    Navigator.push(
        context,
        FlutterDDIMaterialPageRoute(
            module: () => HomeController(),
            builder: (_) => const HomePage(),
        ),
    );
```

### Widget Classes

#### `ApplicationState`, `DependentState`, `SingletonState`
These are abstract classes that help manage the lifecycle of a dependency for a widget. The difference between the three classes is the behavior of the instace that will be registered, where the type will be the second parameter passed in the class declaration.

Example Usage:

```dart
    class HomePage extends StatefulWidget {
        const HomePage({super.key});

        @override
        State<HomePage> createState() => _HomePageState(HomePageController.new);
    }

    class _HomePageState extends ApplicationState<HomePage, HomePageController> {
        _HomePageState(super.clazzRegister);
    }
```

#### `Extension FlutterDDIContext`
The `FlutterDDIContext` extension provides a `get` method that can be used in `BuildContext` to get an instance of a specific type.

Example Usage:

```dart
    class HomePage extends StatelessWidget {
        const HomePage({super.key});

        @override
        Widget build(BuildContext context) {
            final controller = context.get<HomePageController>();

            return Container();
        }
    }
```
