import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:laporin/core/error/failures.dart';
import 'package:laporin/features/auth/domain/entities/user.dart';
import 'package:laporin/features/auth/domain/repositories/auth_repository.dart';
import 'package:laporin/features/auth/domain/usecases/login_usecase.dart';
import 'package:laporin/features/auth/domain/usecases/register_usecase.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_event.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    return const Right(User(id: '1', name: 'Eve', email: 'evelyn@gmail.com', phoneNumber: '+628123456789'));
  }

  @override
  Future<Either<Failure, User>> register(String name, String email, String password, String phoneNumber) async {
    return Right(User(id: '1', name: name, email: email, phoneNumber: phoneNumber));
  }
}

void main() {
  late AuthBloc authBloc;
  late LoginUseCase loginUseCase;
  late RegisterUseCase registerUseCase;
  late FakeAuthRepository fakeAuthRepository;

  setUp(() {
    fakeAuthRepository = FakeAuthRepository();
    loginUseCase = LoginUseCase(fakeAuthRepository);
    registerUseCase = RegisterUseCase(fakeAuthRepository);
    authBloc = AuthBloc(loginUseCase: loginUseCase, registerUseCase: registerUseCase);
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state should be AuthInitial', () {
    expect(authBloc.state, equals(AuthInitial()));
  });

  group('ProfileUpdated', () {
    test('should emit AuthAuthenticated with updated user details when state is AuthAuthenticated', () async {
      authBloc.emit(const AuthAuthenticated(User(id: '123', name: 'Eve', email: 'evelyn@gmail.com', phoneNumber: '12345')));

      final expectedStates = [
        const AuthAuthenticated(User(id: '123', name: 'New Eve', email: 'new_eve@gmail.com', phoneNumber: '54321')),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(const ProfileUpdated(name: 'New Eve', email: 'new_eve@gmail.com', phoneNumber: '54321'));
    });

    test('should emit AuthAuthenticated with default ID when state is not authenticated yet', () async {
      final expectedStates = [
        const AuthAuthenticated(User(id: '1', name: 'Eve New', email: 'evenew@gmail.com', phoneNumber: '99999')),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(const ProfileUpdated(name: 'Eve New', email: 'evenew@gmail.com', phoneNumber: '99999'));
    });
  });

  group('LogoutRequested', () {
    test('should emit AuthInitial when LogoutRequested is added', () async {
      authBloc.emit(const AuthAuthenticated(User(id: '123', name: 'Eve', email: 'evelyn@gmail.com')));

      final expectedStates = [
        AuthInitial(),
      ];

      expectLater(authBloc.stream, emitsInOrder(expectedStates));

      authBloc.add(LogoutRequested());
    });
  });
}
