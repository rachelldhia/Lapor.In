import 'package:laporin/core/network/api_client.dart';
import 'package:laporin/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> register(String name, String email, String password, String phoneNumber);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await client.dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null) {
          return UserModel.fromJson(response.data['data']);
        } else {
          throw Exception('Invalid response format: missing data');
        }
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, String phoneNumber) async {
    try {
      final response = await client.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
        },
      );

      if (response.statusCode == 200) {
        if (response.data != null && response.data['data'] != null) {
          return UserModel.fromJson(response.data['data']);
        } else {
          throw Exception('Invalid response format: missing data');
        }
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      rethrow;
    }
  }
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  // In-memory "database" for the session
  static final List<Map<String, String>> _users = [
    {'username': 'test', 'password': 'test', 'name': 'Test User', 'email': 'test@laporin.id', 'id': '1'}
  ];

  @override
  Future<UserModel> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      final userMap = _users.firstWhere(
        (u) => (u['username'] == username || u['email'] == username) && u['password'] == password,
      );

      return UserModel(
        id: userMap['id']!,
        name: userMap['name']!,
        email: userMap['email']!,
      );
    } catch (_) {
      throw Exception('Invalid username or password (Mock DB)');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password, String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));

    // Check if user already exists
    if (_users.any((u) => u['email'] == email)) {
      throw Exception('User with this email already exists (Mock DB)');
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newUser = {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'username': email.split('@')[0], // Default username from email
      'password': password,
    };

    _users.add(newUser);

    return UserModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
