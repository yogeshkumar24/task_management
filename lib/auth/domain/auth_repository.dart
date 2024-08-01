import 'package:task_management/auth/data/auth_service.dart';
import 'package:task_management/auth/data/model/login_request.dart';
import 'package:task_management/auth/data/model/login_response.dart';

abstract class AuthRepository {
  Future<AuthResponse> register(AuthRequest request);

  Future<AuthResponse> login(AuthRequest request);
}

class UserRepositoryImpl implements AuthRepository {
  final AuthService _authService;

  UserRepositoryImpl(this._authService);

  @override
  Future<AuthResponse> register(AuthRequest request) {
    return _authService.register(request);
  }

  @override
  Future<AuthResponse> login(AuthRequest request) {
    return _authService.login(request);
  }
}
