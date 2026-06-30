import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';
import 'package:mobile/features/auth/data/auth_repository.dart';
import 'package:mobile/features/auth/models/auth_result.dart';
import 'package:mobile/features/auth/models/user_model.dart';
import 'package:mobile/features/auth/models/register_form_data.dart';

class MockAuthRepository extends Mock implements AuthRepository {}
class FakeRegisterFormData extends Fake implements RegisterFormData {}

void main() {
  late AuthCubit authCubit;
  late MockAuthRepository mockAuthRepository;

  setUpAll(() {
    registerFallbackValue(FakeRegisterFormData());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authCubit = AuthCubit(mockAuthRepository);
  });

  group('AuthCubit', () {
    test('initial state has isAuthenticated as false and user as null', () {
      expect(authCubit.state.isAuthenticated, false);
      expect(authCubit.state.user, null);
    });

    blocTest<AuthCubit, AuthState>(
      'login emits a state with isLoading: true followed by a state with isAuthenticated: true on success',
      build: () {
        when(() => mockAuthRepository.login(any(), any())).thenAnswer(
          (_) async => AuthSuccess(
            user: UserModel(id: '1', email: 'test@test.com', fullName: 'Test Name', currencyCode: 'INR'),
            accessToken: 'access',
            refreshToken: 'refresh',
          ),
        );
        return authCubit;
      },
      act: (cubit) => cubit.login('test@test.com', 'password'),
      expect: () => [
        isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AuthState>().having((s) => s.isAuthenticated, 'isAuthenticated', true).having((s) => s.isLoading, 'isLoading', false),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'login emits a state with isLoading: true followed by a state with a non-null errorMessage on API failure',
      build: () {
        when(() => mockAuthRepository.login(any(), any())).thenAnswer(
          (_) async => AuthFailure('Invalid credentials'),
        );
        return authCubit;
      },
      act: (cubit) => cubit.login('test@test.com', 'wrong_password'),
      expect: () => [
        isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AuthState>()
            .having((s) => s.isLoading, 'isLoading', false)
            .having((s) => s.errorMessage, 'errorMessage', isNotNull),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'logout emits a state with isAuthenticated: false and user as null',
      build: () {
        when(() => mockAuthRepository.logout()).thenAnswer((_) async {});
        return authCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.isAuthenticated, 'isAuthenticated', false)
            .having((s) => s.user, 'user', null),
      ],
    );
  });
}
