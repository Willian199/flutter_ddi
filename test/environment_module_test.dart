import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';

void main() {
  test('calls onEnabled when the compile-time value is true', () async {
    final module = _TestEnvironmentModule(enabled: true);

    await module.onPostConstruct();

    expect(module.enabledCalls, 1);
    expect(module.disabledCalls, 0);
  });

  test('calls onDisabled when the compile-time value is false', () async {
    final module = _TestEnvironmentModule(enabled: false);

    await module.onPostConstruct();

    expect(module.enabledCalls, 0);
    expect(module.disabledCalls, 1);
  });
}

final class _TestEnvironmentModule extends DDIEnvironmentModule {
  _TestEnvironmentModule({required super.enabled});

  int enabledCalls = 0;
  int disabledCalls = 0;

  @override
  void onEnabled() => enabledCalls++;

  @override
  void onDisabled() => disabledCalls++;
}
