import 'package:dartz/dartz.dart';
import 'package:laporin/core/error/failures.dart';
import 'package:laporin/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  );
}
