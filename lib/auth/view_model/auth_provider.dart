import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_management/auth/data/model/login_request.dart';
import 'package:task_management/auth/data/model/login_response.dart';
import 'package:task_management/auth/domain/auth_repository.dart';
import 'package:task_management/shared/util/app_utils.dart';
import 'package:task_management/dependency/get_it.dart';
import 'package:task_management/shared/util/storage_helper.dart';
import 'package:task_management/shared/widget/custom_alert_dialog.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository _authRepository;

  AuthProvider(this._authRepository);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _showPassword = false;

  bool get showPassword => _showPassword;

  updatePasswordField() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> register(BuildContext context) async {
    try {
      AuthRequest request = AuthRequest(
        email: emailController.text,
        password: passwordController.text,
      );
      isLoading = true;
      AuthResponse response = await _authRepository.register(request);
      isLoading = false;
      if (response.id != null) {
        await getIt<StorageHelper>().saveUserId(response.id.toString());
        await getIt<StorageHelper>().saveIsLoggedIn(true);
        return true;
      }
      return false;
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        CustomAlertDialog.show(context,
            title: "Error", message: e.message.toString());
      } else {
        AppUtils.showToast(e.toString());
      }
      return false;
    }
  }

  Future<bool> login(BuildContext context) async {
    try {
      AuthRequest request = AuthRequest(
        email: emailController.text,
        password: passwordController.text,
      );
      isLoading = true;
      AuthResponse response = await _authRepository.login(request);
      isLoading = false;
      if (response.token != null) {
        await getIt<StorageHelper>().saveUserId(response.id.toString());
        await getIt<StorageHelper>().saveIsLoggedIn(true);

        return true;
      }
      return false;
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        CustomAlertDialog.show(context,
            title: "Error", message: e.message.toString());
      } else {
        AppUtils.showToast(e.toString());
      }
      return false;
    }
  }

  clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
