// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:mobile/core/di/register_module.dart' as _i815;
import 'package:mobile/core/utils/biometric_service.dart' as _i824;
import 'package:mobile/core/utils/secure_storage_service.dart' as _i201;
import 'package:mobile/core/utils/sync_manager.dart' as _i519;
import 'package:mobile/features/auth/cubit/auth_cubit.dart' as _i450;
import 'package:mobile/features/auth/data/auth_repository.dart' as _i858;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.singleton<_i824.BiometricService>(() => _i824.BiometricService());
    gh.singleton<_i201.SecureStorageService>(
      () => _i201.SecureStorageService(),
    );
    gh.singleton<_i519.SyncManager>(() => _i519.SyncManager());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i858.AuthRepository>(
      () => _i858.AuthRepositoryImpl(gh<_i361.Dio>()),
    );
    gh.singleton<_i450.AuthCubit>(
      () => _i450.AuthCubit(gh<_i858.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i815.RegisterModule {}
