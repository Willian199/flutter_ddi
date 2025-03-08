## 0.8.0
* Bumpped `dart_ddi` to 0.11.0.
* Now the State management works with `Listenable` interface, like `ChangeNotifier` or `ValueNotifier`. This makes the package have a better integration with Flutter.
* Added `ListenableState` and `ListenableMixin`. Reduce the boilerplate code when using `Listenable`, `ChangeNotifier` or `ValueNotifier`.

** Breaking Changes **
* Removed `EventListener` and `StreamListener` mixins.
* Removed `EventListenerState` and `StreamListenerState` abstract classes.

## 0.7.0
* Better support for intercepting module loading.

** Breaking Changes **
* Removed `FlutterDDIFutureModuleRouter`. Use `FlutterDDIRouter` instead.
* Removed route generation from `FlutterDDIRouter.getRoutes(modules:[])`.

## 0.6.0
* Exposed `onEvent` from `EventListener` and `StreamListener`.
* Now if the state is null, the `EventListenerState` and `EventListener` will get the last value fired for the event.
* Bumpped `dart_ddi` to 0.10.0.

## 0.5.1
* Fixed issue with `FlutterDDIBuilder` and `FlutterDDIFutureModuleRouter`, was causing tree's change and losing the context.

## 0.5.0
* Bumpped `dart_ddi` to 0.9.0.

## 0.4.0
* Flutter constraint increased to >=3.24.0.
* Fixed destroy modules, where using Flutter >=3.24.0. Navigator.canPop seems to be broken.

## 0.3.0
* Bumpped `dart_ddi` to 0.8.0.
* Fixes router modules creation and disposal process.

** Breaking Changes **
* Removed `FlutterDDIWidget`. Use `FlutterDDIBuilder` instead.
* Renamed `FlutterDDIFutureWidget` to `FlutterDDIBuilder`.

## 0.2.0
* Bumpped `dart_ddi` to 0.7.0.
* Support for `registerComponent` and `getComponent`. Making Flutter Widgets components easier to reuse.

## 0.1.3

* Bumpped `dart_ddi` to 0.6.6.
* Fixed an bad hot reload behavior with `FlutterDDIFutureWidget` and `FlutterDDIFutureModuleRouter`.

## 0.1.2

* Bumpped `dart_ddi` to 0.6.5.

## 0.1.0 - Breaking Change

* Removed `ApplicationState`, `DependentState` and `SingletonState`. Should use `FlutterDDIWidget` instead.
* Removed `FlutterDDICupertinoPageRoute` and `FlutterDDIMaterialPageRoute`, because they are causing memory leaks.

## 0.0.3
* Bumped `dart_ddi` to 0.6.2.
* Fixed exports.
* Added `FlutterDDIFutureWidget` and `FlutterDDIFutureModuleRouter`.

## 0.0.2

* Bumpped `dart_ddi` to 0.6.1.
* Improved documentation and code organization.
* Added ability to retrieve route data from context with `FlutterDDIContext` extesion.
* Added `EventListener` and `StreamListener` mixins.
* Added `EventListenerState` and `StreamListenerState` abstract classes.

## 0.0.1

* Initial release of `flutter_ddi` package.
* Integration during navigation.
* Enhanced route building.
* Widget dependency injection with `FlutterDDIWidget`.
* Widget management with `ApplicationState`, `DependentState` and `SingletonState`.
* `FlutterDDIContext` extension for context dependency retrieval.
* Module and route definition with `FlutterDDIModule`, `FlutterDDIPage` and `FlutterDDIModuleRouter`.
