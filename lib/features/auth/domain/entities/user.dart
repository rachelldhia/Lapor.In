import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? avatarPath;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.avatarPath,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, avatarPath];
}

