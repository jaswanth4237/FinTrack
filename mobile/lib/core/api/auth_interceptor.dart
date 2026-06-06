import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;
  final FlutterSecureStorage storage;
  final AuthCubit authCubit;
  
  Completer<bool>? _refreshCompleter;

  AuthInterceptor(this.dio, this.storage, this.authCubit);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await storage.read(key: 'access_token');
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_refreshCompleter != null) {
        final success = await _refreshCompleter!.future;
        if (success) {
          return handler.resolve(await _retry(err.requestOptions));
        }
      } else {
        _refreshCompleter = Completer<bool>();
        try {
          final refreshToken = await storage.read(key: 'refresh_token');
          if (refreshToken != null) {
            final response = await dio.post('/auth/refresh', data: {'refresh_token': refreshToken});
            if (response.statusCode == 200) {
              final newAccessToken = response.data['data']['access_token'];
              await storage.write(key: 'access_token', value: newAccessToken);
              _refreshCompleter!.complete(true);
              _refreshCompleter = null;
              return handler.resolve(await _retry(err.requestOptions));
            }
          }
        } catch (e) {
          _refreshCompleter!.complete(false);
          _refreshCompleter = null;
          authCubit.logout(); // Redirect to login
        }
      }
    }
    return handler.next(err);
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final accessToken = await storage.read(key: 'access_token');
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );
    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
