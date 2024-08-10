import 'dart:async';

import 'package:example/model/detail.dart';
import 'package:example/page/details_screen.dart';
import 'package:example/page/first_screen.dart';
import 'package:example/page/home_screen.dart';
import 'package:example/page/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

void main() {
  runApp(const MyApp());
}

// Main Application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DDI Routing Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),

      /// Generated Routes will be:
      ///
      /// {
      ///   '/': (_) => HomeScreen(),
      ///   '/first': (_) => FirstScreen(),
      ///   '/first/details': (_) => DetailsScreen(),
      ///   '/second': (_) => SecondScreen(),
      /// }
      routes: FlutterDDIRouter.getRoutes(
        modules: [
          AppModule(),
        ],
      ),
    );
  }
}

// Main Application Module
class AppModule extends FlutterDDIModuleRouter {
  @override
  String get path => '/';

  @override
  WidgetBuilder get page => (_) => const HomeScreen();

  @override
  List<FlutterDDIModuleDefine> get modules => [
        FirstSubModule(),
        SecondSubModule(),
      ];
}

// First Submodule
class FirstSubModule extends FlutterDDIModuleRouter {
  @override
  String get path => '/first';

  @override
  WidgetBuilder get page => (_) => const FirstScreen();

  @override
  List<FlutterDDIModuleDefine> get modules => [
        DetailsModule(),
      ];
}

// Details Module
class DetailsModule extends FlutterDDIModule {
  @override
  String get path => '/details';

  @override
  WidgetBuilder get page => (_) => DetailsScreen();

  @override
  void onPostConstruct() {
    registerSingleton(() => Detail(message: 'Details Module Loaded'));
  }
}

// Second Submodule
class SecondSubModule extends FlutterDDIModule {
  @override
  String get path => '/second';

  @override
  WidgetBuilder get page => (_) => const SecondScreen();

  @override
  FutureOr<void> onPostConstruct() {
    registerObject('Second Sub Module Loaded', qualifier: 'second_sub');
  }
}
