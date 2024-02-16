import 'package:dart_ddi/dart_ddi.dart';

mixin FlutterController<ControllerT extends Object> {
  ControllerT? _controller;
  ControllerT get controller => _controller ??= DDI.instance.get<ControllerT>();
}

mixin FlutterControllerAsync<ControllerT extends Object> {
  Future<ControllerT>? _controller;
  Future<ControllerT> get controller => _controller ??= DDI.instance.getAsync<ControllerT>();
}
