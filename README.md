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

## Using flutter_ddi

## Defining Modules and Routes

## Defining Modules and Routes

### FlutterDDIModuleRouter
The `FlutterDDIModuleRouter` class is an abstraction that allows defining a module to organize and encapsulate specific dependencies. It simplifies modular navigation and decouples dependency registration.

`interceptors:` This property allows you to define a list of ModuleInterceptor instances that can intercept and handle operations during the module's creation. By default, it returns an empty list but can be extended to handle custom logic, such as logging, security, or validation tasks.

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      initialRoute: '/',
      routes: SplashModule().getRoutes(), // Retrieves the routes from the SplashModule
    );
  }
}
```

## Interceptors

Interceptors provide a way to control and manage application flow during route navigation. They allow to handle custom logic when the module is created.

### Key Methods

A class that extends `FlutterDDIInterceptor` should override the following methods:

- **`onEnter(FlutterDDIModuleDefine instance)`**  
  This method is triggered before accessing the associated module. It should return an instance of `InterceptorResult` to control the flow:
  
  - `InterceptorResult.next`: Proceed to the next Interceptor or load the module.
  - `InterceptorResult.redirect`: Redirect to another page or terminate navigation.
  - `InterceptorResult.stop`: Stop navigation and blocking the module load.

- **`onFail(FlutterDDIModuleDefine instance)`**  
  If `InterceptorResult.stop` is returned from `onEnter`, this method is executed to perform any custom logic. Also, they auto `pop` the navigation.

- **`redirect(BuildContext context)`**  
  If `InterceptorResult.redirect` is returned from `onEnter`, this method is executed to perform the redirection logic. 

---

### Example Usage: Access Control with a Luck-Based Interceptor

The following example demonstrates an interceptor that randomly denies access to a page.

```dart
class Luck extends FlutterDDIInterceptor {
  late final Random random = Random();

  @override
  Future<InterceptorResult> onEnter(FlutterDDIModuleDefine instance) async {
    final r = random.nextInt(10) + 1;

    if (r % 2 != 0) {
      ScaffoldMessenger.of(instance.context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to access this page'),
          duration: Duration(seconds: 3),
        ),
      );

      return InterceptorResult.redirect; // Deny access and trigger redirection
    }

    return InterceptorResult.next; // Allow access
  }

  @override
  FutureOr<void> onFail(FlutterDDIModuleDefine instance) {
    // Handle failure scenarios if needed
  }

  @override
  FutureOr<void> redirect(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/')); // Redirect to the root route
  }
}
```

## Simplified State Management

Managing state in Flutter applications, especially for medium or smaller projects, doesn't always require complex state management solutions. For apps where simplicity and efficiency are key, using these mixins and classes for state management can be a straightforward and effective approach. But for larger and complex projects, it's recommended to use a proper state management solutions.

### How It Works
Under the hood, these mixins utilize the `setState` method to update the widget's state. They handle registering an event or stream in the `initState` and cleaning up in the `dispose` method.

#### Example Usage:

```dart
    class HomePage extends StatefulWidget {
        const HomePage({super.key});

        @override
        State<HomePage> createState() => _HomePageState();
    }

    /// You can extend `StreamListenerState` or `EventListenerState` or use the mixin `StreamListener` or `EventListener`
    class _HomePageState extends StreamListenerState<HomePage, HomePageModel> {
    // class _HomePageState extends EventListenerState<HomePage, HomePageModel> {
    // class _HomePageState extends State<HomePage> with StreamListener<HomePage, HomePageModel> {
    // class _HomePageState extends State<HomePage> with EventListener<HomePage, HomePageModel> {

      Widget build(BuildContext context) {
          return Text('Welcome ${state.name} ${state.surname}');
      } 
    }

    class HomePageModel {
      final String name;
      final String surname;

      HomePageModel(this.name, this.surname);
    }

    class HomePageControler with DDIEventSender<HomePageModel> {
    //class HomePageControler with DDIStreamSender<HomePageModel>{

      String name = 'John'; 
      String surname = 'Wick';

      void update() {
        fire(HomePageModel(name, surname));
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

# Known Limitation

`Circular Routes:` At present, the package does not fully support circular route structures. Defining circular dependencies between routes will lead to errors during the module registration process.


Any help, suggestions, corrections are welcome.
