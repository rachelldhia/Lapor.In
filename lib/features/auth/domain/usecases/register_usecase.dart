import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:laporin/core/error/failures.dart';
import 'package:laporin/core/usecases/usecase.dart';
import 'package:laporin/features/auth/domain/entities/user.dart';
import 'package:laporin/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.register(
      params.name,
      params.email,
      params.password,
      params.phoneNumber,
    );
  }
}

class RegisterParams extends Equatable {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, email, password, phoneNumber];
}
