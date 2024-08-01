import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:task_management/auth/data/model/login_request.dart';
import 'package:task_management/auth/data/model/login_response.dart';
import 'package:task_management/shared/api_endpoints.dart';
import 'package:task_management/shared/log.dart';

abstract class AuthServiceBase {
  Future<AuthResponse> register(AuthRequest request);

  Future<AuthResponse> login(AuthRequest request);
}

class AuthService implements AuthServiceBase {
  final Dio dio = Dio();

  @override
  Future<AuthResponse> register(AuthRequest request) async {
    final response = await dio.post(ApiEndpoints.register,
        data: jsonEncode(request.toJson()),
        options: Options(
          headers: {'content-Type': 'application/json'},
        ));
    Log.d(response.toString());
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data);
    } else {
      throw Exception("Failed to register");
    }
  }

  @override
  Future<AuthResponse> login(AuthRequest request) async {
    final response = await dio.post(ApiEndpoints.login,
        data: jsonEncode(request.toJson()),
        options: Options(
          headers: {'content-Type': 'application/json'},
        ));
    Log.d(response.toString());
    if (response.statusCode == 200) {
      return AuthResponse.fromJson(response.data);
    } else {
      throw Exception("Failed to login");
    }
  }
}
