import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:mobile/features/auth/models/register_form_data.dart';


class AuthState {
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    UserModel? user,
    String? accessToken,
    String? refreshToken,
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

@singleton
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _authRepository.login(email, password);
    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (data) => emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: data.user,
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      )),
    );
  }

  Future<void> register(RegisterFormData data) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _authRepository.register(data.toJson());
    result.fold(
      (error) => emit(state.copyWith(isLoading: false, errorMessage: error)),
      (data) => emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        user: data.user,
        accessToken: data.accessToken,
        refreshToken: data.refreshToken,
      )),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(AuthState());
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      emit(state.copyWith(isLoading: false, isAuthenticated: true, user: user));
    } else {
      emit(state.copyWith(isLoading: false, isAuthenticated: false));
    }
  }
}
