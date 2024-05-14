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
