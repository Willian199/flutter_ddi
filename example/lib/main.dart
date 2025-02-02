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
      initialRoute: '/',
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

      return InterceptorResult.redirect;
    }

    return InterceptorResult.next;
  }

  @override
  FutureOr<void> redirect(BuildContext context) {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
  }
}

// First Submodule
class FirstSubModule extends FlutterDDIRouter {
  @override
  String get path => '/first';

  @override
  WidgetBuilder get page => (_) => const FirstScreen();

  @override
  List<ModuleInterceptor> get interceptors => [
        ModuleInterceptor.of(factory: Luck.new.builder.asApplication()),
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
  List<ModuleInterceptor> get interceptors => [
        ModuleInterceptor<Luck>.from(),
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
  List<ModuleInterceptor> get interceptors => [
        ModuleInterceptor.of(factory: Luck.new.builder.asApplication()),
      ];

  @override
  FutureOr<void> onPostConstruct() {
    registerObject('Second Sub Module Loaded', qualifier: 'second_sub');
  }
}
