import 'package:flutter/material.dart';

class RouterOutlet extends StatefulWidget {
  const RouterOutlet({
    required this.initialRoute,
    required this.routes,
    super.key,
  });
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;

  @override
  State<RouterOutlet> createState() => _RouterOutletState();

  static NavigatorState of(BuildContext context) {
    final state = context.findAncestorStateOfType<_RouterOutletState>();
    if (state == null) {
      throw Exception('RouterOutletState not found in the widget tree.');
    }
    return state.navigator;
  }
}

class _RouterOutletState extends State<RouterOutlet> {
  late final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RouterOutlet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialRoute != oldWidget.initialRoute) {
      navigator.pushNamedAndRemoveUntil(
        widget.initialRoute,
        ModalRoute.withName(oldWidget.initialRoute),
      );
    }
  }

  NavigatorState get navigator =>
      Navigator.of(navigatorKey.currentState?.context ?? context);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: widget.initialRoute,
      onGenerateRoute: (settings) {
        final routeBuilder = widget.routes[settings.name];
        if (routeBuilder != null) {
          return MaterialPageRoute(
            builder: routeBuilder,
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
          settings: settings,
        );
      },
    );
  }
}
