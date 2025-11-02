import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_ddi/flutter_ddi.dart';
import '../mocks/test_mocks.dart';

void main() {
  group('Widget Scope Limitations', () {
    test('should not support interceptors', () async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      // Try to add interceptor - should assert or throw
      expect(
        () => ddi.addInterceptor<MockTestWidget>(
          {MockTestService},
        ),
        throwsA(anything),
      );

      await ddi.destroy<MockTestWidget>();
    });

    test('should not support decorators', () async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      // Try to add decorator - should assert or throw
      expect(
        () => ddi.addDecorator<MockTestWidget>(
          [(instance) => instance],
        ),
        throwsA(anything),
      );

      await ddi.destroy<MockTestWidget>();
    });

    test('should not support children', () async {
      await ddi.widget<MockTestWidget>(MockTestWidget.new);

      // Try to add child - should assert or throw
      expect(
        () => ddi.addChildModules<MockTestWidget>(
          child: MockTestService,
        ),
        throwsA(anything),
      );

      await ddi.destroy<MockTestWidget>();
    });
  });
}
