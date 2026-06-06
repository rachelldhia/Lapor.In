import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:laporin/core/error/failures.dart';
import 'package:laporin/core/usecases/usecase.dart';
import 'package:laporin/features/auth/domain/entities/user.dart';
import 'package:laporin/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.username, params.password);
  }
}

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
