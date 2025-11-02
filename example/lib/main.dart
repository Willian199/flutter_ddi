import 'dart:async';
import 'dart:math';

import 'package:example/exception/interceptor_blocked.dart';
import 'package:example/model/detail.dart';
import 'package:example/page/details_screen.dart';
import 'package:example/page/first_screen.dart';
import 'package:example/page/home_screen.dart';
import 'package:example/page/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

void main() {
  runApp(MyApp());
}

// Main Application
class MyApp extends StatelessWidget {
  MyApp({super.key});

  late final AppModule appModule = AppModule();

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
      ///   '/second': (_) => SecondScreen(),
      /// }
      routes: appModule.getRoutes(),
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

class Luck extends DDIInterceptor<FlutterDDIModuleDefine> {
  late final Random random = Random();

  @override
  Future<FlutterDDIModuleDefine> onCreate(
      FlutterDDIModuleDefine instance) async {
    final r = random.nextInt(10) + 1;
    if (r % 2 != 0) {
      ScaffoldMessenger.of(instance.context).showSnackBar(
        const SnackBar(
          content: Text('You are not allowed to access this page'),
          duration: Duration(seconds: 3),
        ),
      );

      Navigator.of(instance.context).pop();

      throw const InterceptorBlockedException('stop');
    }

    return instance;
  }
}

// First Submodule
class FirstSubModule extends FlutterDDIOutletModule {
  @override
  String get path => '/first';

  @override
  WidgetBuilder get page => (_) => const FirstScreen();

  @override
  List<ModuleInterceptor> get interceptors => [
        ModuleInterceptor<Luck>.of(
            factory: ApplicationFactory<Luck>(builder: Luck.new.builder)),
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
  WidgetBuilder get page => (_) => const DetailsScreen();

  @override
  List<ModuleInterceptor> get interceptors => [
        ModuleInterceptor<Luck>.from(),
      ];

  @override
  void onPostConstruct() {
    singleton(() => Detail(message: 'Details Router Outlet Module Loaded'));
  }
}

// Second Submodule
class SecondSubModule extends FlutterDDIModuleRouter {
  @override
  String get path => '/second';

  @override
  WidgetBuilder get page => (_) => SecondScreen();

  @override
  List<ModuleInterceptor> get interceptors => [
        ModuleInterceptor<Luck>.of(
            factory: ApplicationFactory<Luck>(builder: Luck.new.builder)),
      ];

  @override
  FutureOr<void> onPostConstruct() {
    object('Second Sub Module Loaded', qualifier: 'second_sub');
  }
}
