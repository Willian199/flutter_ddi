import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import '../mocks/test_mocks.dart';

void main() {
  group('FlutterDDICustomBuilderExtension - asWidget()', () {
    test('should register widget with asWidget()', () async {
      await MockTestWidget.new.builder.asWidget();

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      final instance1 = ddi.get<MockTestWidget>();
      final instance2 = ddi.get<MockTestWidget>();

      expect(instance1, isA<MockTestWidget>());
      expect(instance2, isA<MockTestWidget>());
      expect(instance1, isNot(same(instance2)));

      await ddi.destroy<MockTestWidget>();
    });

    test('should register widget with qualifier', () async {
      const qualifier = 'testWidget';
      await MockTestWidget.new.builder.asWidget(qualifier: qualifier);

      expect(ddi.isRegistered<MockTestWidget>(qualifier: qualifier), isTrue);

      final instance = ddi.get<MockTestWidget>(qualifier: qualifier);
      expect(instance, isA<MockTestWidget>());

      await ddi.destroy<MockTestWidget>(qualifier: qualifier);
    });

    test('should register widget with canDestroy false', () async {
      await MockIndestructibleWidget2.new.builder.asWidget(canDestroy: false);

      expect(ddi.isRegistered<MockIndestructibleWidget2>(), isTrue);

      // Try to destroy - should not work
      await ddi.destroy<MockIndestructibleWidget2>();

      // Should still be registered
      expect(ddi.isRegistered<MockIndestructibleWidget2>(), isTrue);
    });

    test('should register widget with canRegister condition', () async {
      bool shouldRegister = false;

      await MockTestWidget.new.builder.asWidget(
        canRegister: () => shouldRegister,
      );

      expect(ddi.isRegistered<MockTestWidget>(), isFalse);

      shouldRegister = true;

      await MockTestWidget.new.builder.asWidget(
        canRegister: () => shouldRegister,
      );

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      await ddi.destroy<MockTestWidget>();
    });

    test('should register widget with selector', () async {
      await MockTestWidget.new.builder.asWidget(
        selector: (qualifier) => qualifier == 'selected',
      );

      expect(ddi.isRegistered<MockTestWidget>(), isTrue);

      final instance =
          ddi.get<MockTestWidget>(select: 'selected', qualifier: 'wrong');
      expect(instance, isA<MockTestWidget>());

      await ddi.destroy<MockTestWidget>();
    });

    test('should call PostConstruct when widget implements it', () async {
      await MockPostConstructWidget2.new.builder.asWidget();

      final instance = ddi.get<MockPostConstructWidget2>();

      expect(instance, isA<MockPostConstructWidget2>());
      expect(instance.initialized, isTrue);

      await ddi.destroy<MockPostConstructWidget2>();
    });
  });
}
