import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_management/profile/data/model/user_model.dart';
import 'package:task_management/profile/domain/profile_repository.dart';
import 'package:task_management/shared/util/app_utils.dart';
import 'package:task_management/shared/widget/custom_alert_dialog.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _profileRepository;

  ProfileProvider(this._profileRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<User> _userList = [];

  List<User> get userList => _userList;

  User? _user;

  User? get user => _user;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> getAllUsers(BuildContext context) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      AppUtils.showToast("Please Check Your Internet Connection");
    } else {
      try {
        isLoading = true;
        _userList = await _profileRepository.getAllUsers();
        isLoading = false;
      } catch (e) {
        isLoading = false;
        if (e is DioException) {
          CustomAlertDialog.show(context,
              title: "Error", message: e.message.toString());
        } else {
          AppUtils.showToast(e.toString());
        }
      }
    }
  }

  Future<void> getUser(BuildContext context, int id) async {
    try {
      isLoading = true;
      _user = await _profileRepository.getUser(id);
      isLoading = false;
    } catch (e) {
      isLoading = false;
      if (e is DioException) {
        CustomAlertDialog.show(context,
            title: "Error", message: e.message.toString());
      } else {
        AppUtils.showToast(e.toString());
      }
    }
  }
}
