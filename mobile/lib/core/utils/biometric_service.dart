import 'package:local_auth/local_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/core/utils/secure_storage_service.dart';
import 'package:mobile/core/di/injection.dart';

@singleton
class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();
  final SecureStorageService _secureStorage = getIt<SecureStorageService>();

  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
    return canAuthenticate;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access FinTrack',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  Future<void> enableBiometric() async {
    await _secureStorage.saveString('biometric_enabled', 'true');
  }

  Future<void> disableBiometric() async {
    await _secureStorage.saveString('biometric_enabled', 'false');
  }

  Future<bool> isBiometricEnabled() async {
    final enabled = await _secureStorage.getString('biometric_enabled');
    return enabled == 'true';
  }
}
