import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/constants/app_constants.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));
}
