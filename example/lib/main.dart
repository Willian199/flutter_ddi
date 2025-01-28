import 'dart:async';
import 'dart:math';

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
      routes: AppModule().getRoutes(),
    );
  }
}

// Main Application Module
class AppModule extends FlutterDDIRouter {
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

class Luck extends FlutterDDIMiddleware {
  late final Random random = Random();

  @override
  Future<FlutterDDIModuleDefine> onGet(FlutterDDIModuleDefine instance) async {
    final r = random.nextInt(10) + 1;
    if (r % 2 != 0) {
      Navigator.of(instance.context).maybePop();

      ScaffoldMessenger.of(instance.context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to access this page'),
          duration: Duration(seconds: 3),
        ),
      );
    }

    return super.onGet(instance);
  }

  /*@override
  // TODO Fix: Currently don't block pop()
  FutureOr<void> onDestroy(FlutterDDIModuleDefine? instance) {
    final r = random.nextInt(10) + 1;
    if (r % 2 == 0) {
      //throw UnimplementedError();
    }
  }*/
}

// First Submodule
class FirstSubModule extends FlutterDDIRouter {
  @override
  String get path => '/first';

  @override
  WidgetBuilder get page => (_) => const FirstScreen();

  @override
  List<Middleware> get middlewares => [
        Middleware.of(factory: Luck.new.builder.asApplication()),
      ];

  @override
  List<FlutterDDIModuleDefine> get modules => [
        DetailsModule(),
      ];
}

// Details Module
class DetailsModule extends FlutterDDIModuleRouter {
  @override
  String get path => '/details';

  @override
  WidgetBuilder get page => (_) => DetailsScreen();

  @override
  List<Middleware> get middlewares => [
        Middleware<Luck>.from(),
      ];

  @override
  void onPostConstruct() {
    registerSingleton(() => Detail(message: 'Details Module Loaded'));
  }
}

// Second Submodule
class SecondSubModule extends FlutterDDIModuleRouter {
  @override
  String get path => '/second';

  @override
  WidgetBuilder get page => (_) => const SecondScreen();

  @override
  List<Middleware> get middlewares => [
        Middleware.of(factory: Luck.new.builder.asApplication()),
      ];

  @override
  FutureOr<void> onPostConstruct() {
    registerObject('Second Sub Module Loaded', qualifier: 'second_sub');
  }
}
