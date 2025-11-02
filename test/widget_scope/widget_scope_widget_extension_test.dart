import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import '../mocks/test_mocks.dart';

void main() {
  group('FlutterDDIRegisterExtension - widget()', () {
    test('should register widget with widget() method', () async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      final instance1 = ddi.get<MockTestWidget>();
      final instance2 = ddi.get<MockTestWidget>();

      expect(instance1, isA<MockTestWidget>());
      expect(instance2, isA<MockTestWidget>());
      expect(instance1, isNot(same(instance2)));

      await ddi.destroy<MockTestWidget>();
    });

    test('should register widget with qualifier', () async {
      const qualifier = 'widgetQualifier';
      await ddi.widget<MockTestWidget>(
        MockTestWidget.new,
        qualifier: qualifier,
      );

      expect(ddi.isRegistered<MockTestWidget>(qualifier: qualifier), isTrue);

      final instance = ddi.get<MockTestWidget>(qualifier: qualifier);
      expect(instance, isA<MockTestWidget>());

      await ddi.destroy<MockTestWidget>(qualifier: qualifier);
    });

    test('should register widget with canDestroy false', () async {
      await ddi.widget<MockIndestructibleWidget3>(
        MockIndestructibleWidget3.new,
        canDestroy: false,
      );

      expect(ddi.isRegistered<MockIndestructibleWidget3>(), isTrue);

      await ddi.destroy<MockIndestructibleWidget3>();

      // Should still be registered
      expect(ddi.isRegistered<MockIndestructibleWidget3>(), isTrue);

      // Force cleanup with dispose for test cleanup
      await ddi.dispose<MockIndestructibleWidget3>();
    });

    test('should register widget with canRegister condition', () async {
      bool shouldRegister = false;

      await ddi.widget<MockTestWidget>(
        MockTestWidget.new,
        canRegister: () async => shouldRegister,
      );

      expect(ddi.isRegistered<MockTestWidget>(), isFalse);

      shouldRegister = true;

      await ddi.widget<MockTestWidget>(
        MockTestWidget.new,
        canRegister: () async => shouldRegister,
      );

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      await ddi.destroy<MockTestWidget>();
    });

    test('should register widget with selector', () async {
      await ddi.widget<MockTestWidget>(
        MockTestWidget.new,
        selector: (qualifier) => qualifier == 'selected',
      );

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      final instance = ddi.get<MockTestWidget>();
      expect(instance, isA<MockTestWidget>());

      await ddi.destroy<MockTestWidget>();
    });

    test('should create new instance each time', () async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      final instances = <MockTestWidget>[];
      for (int i = 0; i < 5; i++) {
        instances.add(ddi.get<MockTestWidget>());
      }

      // All instances should be different
      for (int i = 0; i < instances.length; i++) {
        for (int j = i + 1; j < instances.length; j++) {
          expect(instances[i], isNot(same(instances[j])));
        }
      }

      await ddi.destroy<MockTestWidget>();
    });

    test('should work with widget parameter', () async {
      await ddi
          .widget<MockParamWidget>(() => const MockParamWidget(message: 'Test'));

      final instance = ddi.get<MockParamWidget>();
      expect(instance.message, equals('Test'));

      await ddi.destroy<MockParamWidget>();
    });
  });
}

