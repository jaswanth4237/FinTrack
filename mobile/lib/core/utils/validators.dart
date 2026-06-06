import 'package:reactive_forms/reactive_forms.dart';

class AppValidators {
  static Map<String, dynamic>? passwordStrength(AbstractControl control) {
    if (control.value == null || control.value.toString().isEmpty) {
      return null;
    }

    final password = control.value.toString();
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasDigits || !hasSpecialCharacters) {
      return {'passwordStrength': true};
    }

    return null;
  }

  static ValidatorFunction mustMatch(String controlName, String matchingControlName) {
    return (AbstractControl<dynamic> control) {
      final form = control as FormGroup;
      final mainControl = form.control(controlName);
      final matchingControl = form.control(matchingControlName);

      if (mainControl.value != matchingControl.value) {
        matchingControl.setErrors({'mustMatch': true});
      } else {
        matchingControl.removeError('mustMatch');
      }

      return null;
    };
  }
}
