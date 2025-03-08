import 'package:dart_ddi/dart_ddi.dart';
import 'package:flutter/widgets.dart';

abstract class ListenableState<StateT extends StatefulWidget, BeanT extends Listenable> extends State<StateT> with ListenableMixin<StateT, BeanT> {}

mixin ListenableMixin<StateT extends StatefulWidget, BeanT extends Listenable> on State<StateT> {
  late final BeanT listenable = ddi.get<BeanT>();

  @override
  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    listenable.addListener(_handleChange);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    listenable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    (context as Element).markNeedsBuild();
  }
}
