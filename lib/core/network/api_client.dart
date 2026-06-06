import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient()
    : dio = Dio(
        BaseOptions(
          baseUrl:
              'https://api.laporin.id/v1', // Replace with your actual API URL
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
}
