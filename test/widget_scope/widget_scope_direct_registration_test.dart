// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import '../mocks/test_mocks.dart';

void main() {
  group('Widget Scope via DDI - Direct Registration', () {
    test('should create a new instance on each get', () async {
      await ddi.register<MockTestWidget>(
        factory: WidgetFactory<MockTestWidget>(
          builder: MockTestWidget.new.builder,
          canDestroy: true,
        ),
      );

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);
      expect(ddi.isReady<MockTestWidget>(),
          isFalse); // Always false for WidgetFactory
      expect(ddi.isFuture<MockTestWidget>(), isFalse);

      // Get first instance
      final instance1 = ddi.get<MockTestWidget>();
      expect(instance1, isA<MockTestWidget>());

      // Get second instance
      final instance2 = ddi.get<MockTestWidget>();
      expect(instance2, isA<MockTestWidget>());

      // Instances should be different
      expect(instance1, isNot(same(instance2)));

      await ddi.destroy<MockTestWidget>();
    });

    test('should create instance with parameter', () async {
      await ddi.register<MockParamWidget>(
        factory: WidgetFactory<MockParamWidget>(
          builder: CustomBuilder<MockParamWidget>(
            producer: (String message) => MockParamWidget(message: message),
            parametersType: [String],
            returnType: MockParamWidget,
            isFuture: false,
          ),
          canDestroy: true,
        ),
      );

      final instance = ddi.getWith<MockParamWidget, String>(
        parameter: 'Test Message',
      );

      expect(instance, isA<MockParamWidget>());
      expect(instance.message, equals('Test Message'));

      await ddi.destroy<MockParamWidget>();
    });

    test('should call PostConstruct when implemented', () async {
      await ddi.register<MockPostConstructWidget2>(
        factory: WidgetFactory<MockPostConstructWidget2>(
          builder: MockPostConstructWidget2.new.builder,
          canDestroy: true,
        ),
      );

      final instance = ddi.get<MockPostConstructWidget2>();

      expect(instance, isA<MockPostConstructWidget2>());
      expect(instance.initialized, isTrue);

      await ddi.destroy<MockPostConstructWidget2>();
    });

    test('should create widget instance', () async {
      const qualifier = 'testModule';
      await ddi.register<MockModuleWidget>(
        factory: WidgetFactory<MockModuleWidget>(
          builder: MockModuleWidget.new.builder,
          canDestroy: true,
        ),
        qualifier: qualifier,
      );

      final instance = ddi.get<MockModuleWidget>(qualifier: qualifier);

      expect(instance, isA<MockModuleWidget>());
      expect(instance, isNotNull);

      await ddi.destroy<MockModuleWidget>(qualifier: qualifier);
    });

    test('should create async instance', () async {
      await ddi.register<MockTestWidget>(
        factory: WidgetFactory<MockTestWidget>(
          builder: MockTestWidget.new.builder,
          canDestroy: true,
        ),
      );

      final instance = await ddi.getAsync<MockTestWidget>();

      expect(instance, isA<MockTestWidget>());

      await ddi.destroy<MockTestWidget>();
    });

    test('should destroy when canDestroy is true', () async {
      await ddi.register<MockTestWidget>(
        factory: WidgetFactory<MockTestWidget>(
          builder: MockTestWidget.new.builder,
          canDestroy: true,
        ),
      );

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      await ddi.destroy<MockTestWidget>();

      expect(ddi.isRegistered<MockTestWidget>(), isFalse);
    });

    test('should not destroy when canDestroy is false', () async {
      await ddi.register<MockIndestructibleWidget>(
        factory: WidgetFactory<MockIndestructibleWidget>(
          builder: MockIndestructibleWidget.new.builder,
          canDestroy: false,
        ),
      );

      expect(ddi.isRegistered<MockIndestructibleWidget>(), isTrue);

      await ddi.destroy<MockIndestructibleWidget>();

      // Should still be registered
      expect(ddi.isRegistered<MockIndestructibleWidget>(), isTrue);

      // Force cleanup with dispose for test cleanup
      await ddi.dispose<MockIndestructibleWidget>();
    });

    test('should dispose via DDI', () async {
      await ddi.register<MockTestWidget>(
        factory: WidgetFactory<MockTestWidget>(
          builder: MockTestWidget.new.builder,
          canDestroy: true,
        ),
      );

      await ddi.dispose<MockTestWidget>();

      // Dispose should complete without error
      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      await ddi.destroy<MockTestWidget>();

      expect(ddi.isRegistered<MockTestWidget>(), isFalse);
    });

    test('should throw exception when trying to get destroyed widget',
        () async {
      await ddi.register<MockTestWidget>(
        factory: WidgetFactory<MockTestWidget>(
          builder: MockTestWidget.new.builder,
          canDestroy: true,
        ),
      );

      await ddi.destroy<MockTestWidget>();

      expect(
        () => ddi.get<MockTestWidget>(),
        throwsA(isA<Exception>()),
      );
    });

    test('Widget Scope should be efficient', () {
      const interaction = 10000000;

      final sw = Stopwatch()..start();

      ddi.widget(MockPostConstructCount.new);

      // Simulate 10,000,000 dependency resolutions
      for (var i = 0; i < interaction; i++) {
        ddi.get<MockPostConstructCount>();
      }

      sw.stop();

      final interceptor = ddi.get<MockPostConstructCount>();
      // Validation

      expect(
        interceptor.contador,
        equals(1),
        reason: 'Should increment the value run on each get.',
      );

      // Sanity check for performance
      expect(
        sw.elapsedMilliseconds,
        lessThan(1100),
        reason:
            'Should resolve 10,000,000 instances in under 1100ms on a modern CPU.',
      );

      ddi.destroy<MockPostConstructCount>();

      expect(
        () => ddi.get<MockPostConstructCount>(),
        throwsA(isA<BeanNotFoundException>()),
      );
    });
  });
}
