import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/debounce_utils.dart';

void main() {
  group('Debouncer', () {
    test('The action is not called before the delay has elapsed', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
      bool called = false;
      debouncer.run(() => called = true);
      
      await Future.delayed(const Duration(milliseconds: 200));
      expect(called, false);
      debouncer.dispose();
    });

    test('The action is called after the delay has elapsed', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
      bool called = false;
      debouncer.run(() => called = true);
      
      await Future.delayed(const Duration(milliseconds: 600));
      expect(called, true);
      debouncer.dispose();
    });

    test('Calling run multiple times within the delay only triggers the action once', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 500));
      int callCount = 0;
      
      debouncer.run(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 200));
      debouncer.run(() => callCount++);
      await Future.delayed(const Duration(milliseconds: 200));
      debouncer.run(() => callCount++);
      
      await Future.delayed(const Duration(milliseconds: 600));
      expect(callCount, 1);
      debouncer.dispose();
    });
  });
}
