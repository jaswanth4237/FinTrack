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
        isA<AuthState>().having((s) => s.isAuthenticated, 'isAuthenticated', true),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'register emits success states',
      build: () {
        when(() => mockAuthRepository.register(any())).thenAnswer(
          (_) async => AuthSuccess(
            user: UserModel(id: '1', email: 'test@test.com', fullName: 'Test Name', currencyCode: 'INR'),
            accessToken: 'access',
            refreshToken: 'refresh',
          ),
        );
        return authCubit;
      },
      act: (cubit) => cubit.register(RegisterFormData(email: 'a@b.com', password: 'P1!', fullName: 'A B')),
      expect: () => [
        isA<AuthState>().having((s) => s.isLoading, 'isLoading', true),
        isA<AuthState>().having((s) => s.isAuthenticated, 'isAuthenticated', true),
      ],
    );
  });
}
