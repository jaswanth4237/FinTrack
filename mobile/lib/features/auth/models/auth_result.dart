import 'package:mobile/features/auth/models/user_model.dart';

abstract class AuthResult {
  const AuthResult();
  
  void fold<T>(
    void Function(String error) onFailure,
    void Function(AuthSuccess success) onSuccess,
  ) {
    if (this is AuthFailure) {
      onFailure((this as AuthFailure).error);
    } else if (this is AuthSuccess) {
      onSuccess(this as AuthSuccess);
    }
  }
}

class AuthSuccess extends AuthResult {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthSuccess({required this.user, required this.accessToken, required this.refreshToken});
}

class AuthFailure extends AuthResult {
  final String error;

  AuthFailure(this.error);
}
