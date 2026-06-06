import 'package:flutter_test/flutter_test.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:mobile/core/utils/validators.dart';

void main() {
  group('AppValidators.passwordStrength', () {
    test('passwordStrength returns null for a valid strong password', () {
      final control = FormControl<String>(value: 'Strong123!');
      final result = AppValidators.passwordStrength(control);
      expect(result, null);
    });

    test('passwordStrength returns a non-null error map for a password without an uppercase letter', () {
      final control = FormControl<String>(value: 'weak123!');
      final result = AppValidators.passwordStrength(control);
      expect(result, isNotNull);
      expect(result!['passwordStrength'], true);
    });

    test('passwordStrength returns a non-null error map for a password without a number', () {
      final control = FormControl<String>(value: 'NoNumber!');
      final result = AppValidators.passwordStrength(control);
      expect(result, isNotNull);
      expect(result!['passwordStrength'], true);
    });

    test('passwordStrength returns a non-null error map for a password without a special character', () {
      final control = FormControl<String>(value: 'NoSpecial1');
      final result = AppValidators.passwordStrength(control);
      expect(result, isNotNull);
      expect(result!['passwordStrength'], true);
    });
  });
}
