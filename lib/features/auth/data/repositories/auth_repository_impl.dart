import 'package:dartz/dartz.dart';
import 'package:laporin/core/error/failures.dart';
import 'package:laporin/features/auth/domain/entities/user.dart';
import 'package:laporin/features/auth/domain/repositories/auth_repository.dart';
import 'package:laporin/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final user = await remoteDataSource.login(username, password);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
    String name,
    String email,
    String password,
    String phoneNumber,
  ) async {
    try {
      final user = await remoteDataSource.register(name, email, password, phoneNumber);
      return Right(user);
    } on DioException catch (e) {
      return Left(ServerFailure(_handleDioError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout with server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in association with server';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with server';
      case DioExceptionType.badResponse:
        final message = e.response?.data['message'];
        return message ?? 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request to server was cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error, please check your internet';
      default:
        return 'Something went wrong';
    }
  }
}
