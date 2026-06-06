import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;

  const RegisterSubmitted({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [name, email, password, phoneNumber];
}

class ProfileUpdated extends AuthEvent {
  final String name;
  final String email;
  final String phoneNumber;
  final String? avatarPath;

  const ProfileUpdated({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [name, email, phoneNumber, avatarPath];
}

class LogoutRequested extends AuthEvent {}

