# Flutter DDI Library

The `flutter_ddi` is a package for Flutter that simplifies and enhances integration with [`dart_ddi`](https://github.com/Willian199/dart_ddi), a dependency injection manager for Dart. This package is designed to facilitate the dependency injection process in your Flutter application, making it cleaner, organized, and easy to maintain.

## Features

The `flutter_ddi` offers a range of features that can be easily integrated into your Flutter application. You can choose to use or not the route management provided by the package. If preferred, you can integrate `flutter_ddi` solely for dependency injection, maintaining your own route logic.

- **Integration during navigation**: While navigating between screens, you can utilize `flutter_ddi` without the need to create routes. The package simplifies passing dependencies to new screens.

- **Enhanced route building**: By using `flutter_ddi` to construct your routes, you improve code organization by separating navigation logic from object creation logic.

- **Improved code organization**: By separating navigation and dependency structures from screen and business logics, your code becomes more organized and easier to maintain, especially in large and complex projects.

- **Flexibility and scalability**: This package is designed to be flexible and scalable, allowing you to add and change dependencies as needed without impact on other parts of the code.

## Using flutter_ddi

## Defining Modules and Routes

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

## Navigation-related Classes

### FlutterDDICupertinoPageRoute
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

### FlutterDDIMaterialPageRoute
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

    /// Using can use the mixin `StreamListener` or `EventListener`
    class _HomePageState extends State<HomePage> with StreamListener<HomePage, HomePageModel> {
    // class _HomePageState extends State<HomePage> with EventListener<HomePage, HomePageModel> {

      Widget build(BuildContext context) {
          return Text('Welcome ${state.name} ${state.surname}');
      }
      
    }
```

## Widget Classes

### ApplicationState, DependentState, SingletonState
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
