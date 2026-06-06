import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/utils/secure_storage_service.dart';
import 'package:mobile/features/auth/models/auth_result.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:mobile/core/di/injection.dart';

abstract class AuthRepository {
  Future<AuthResult> login(String email, String password);
  Future<AuthResult> register(dynamic data);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;
  final SecureStorageService _storage = getIt<SecureStorageService>();

  AuthRepositoryImpl(this._dio);

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      final accessToken = data['access_token'];
      final refreshToken = data['refresh_token'];
      
      await _storage.saveAccessToken(accessToken);
      await _storage.saveRefreshToken(refreshToken);
      
      return AuthSuccess(user: user, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  @override
  Future<AuthResult> register(dynamic data) async {
    try {
      final response = await _dio.post('/auth/register', data: data);
      
      final resData = response.data['data'];
      final user = UserModel.fromJson(resData['user']);
      final accessToken = resData['access_token'];
      final refreshToken = resData['refresh_token'];
      
      await _storage.saveAccessToken(accessToken);
      await _storage.saveRefreshToken(refreshToken);
      
      return AuthSuccess(user: user, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      return AuthFailure(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      await _dio.post('/auth/logout', data: {'refresh_token': refreshToken});
    } catch (e) {
      // Ignore
    } finally {
      await _storage.clearAll();
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return UserModel.fromJson(response.data['data']['user']);
    } catch (e) {
      return null;
    }
  }
}
