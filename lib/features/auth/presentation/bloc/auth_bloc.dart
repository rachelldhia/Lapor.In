import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laporin/features/auth/domain/entities/user.dart';
import 'package:laporin/features/auth/domain/usecases/login_usecase.dart';
import 'package:laporin/features/auth/domain/usecases/register_usecase.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_event.dart';
import 'package:laporin/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthBloc({required this.loginUseCase, required this.registerUseCase})
    : super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<ProfileUpdated>(_onProfileUpdated);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(username: event.username, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        phoneNumber: event.phoneNumber,
      ),
    );

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  void _onProfileUpdated(
    ProfileUpdated event,
    Emitter<AuthState> emit,
  ) {
    if (state is AuthAuthenticated) {
      final currentUser = (state as AuthAuthenticated).user;
      final updatedUser = User(
        id: currentUser.id,
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
        avatarPath: event.avatarPath ?? currentUser.avatarPath,
      );
      emit(AuthAuthenticated(updatedUser));
    } else {
      final updatedUser = User(
        id: '1',
        name: event.name,
        email: event.email,
        phoneNumber: event.phoneNumber,
        avatarPath: event.avatarPath,
      );
      emit(AuthAuthenticated(updatedUser));
    }
  }

  void _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) {
    emit(AuthInitial());
  }
}

