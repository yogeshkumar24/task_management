import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/shared/log.dart';

class StorageHelper {
  static const String _userId = "userId";
  static const String _userToken = "userToken";
  static const String _isLoggedIn = "isLogin";
  static final StorageHelper _singleton = StorageHelper._internal();

  StorageHelper._internal();

  factory StorageHelper() {
    return _singleton;
  }

  Future<void> _savePref(String key, Object? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    }
  }

  Future<T?> _getPref<T>(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key) as T?;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String?> getUserId() async {
    return await _getPref<String>(_userId);
  }

  Future<void> saveUserId(String? id) async {
    await _savePref(_userId, id);
  }

  Future<String?> getUserToken() async {
    try {
      return await _getPref<String>(_userToken);
    } catch (e) {
      Log.e("getUserToken ${e.toString()}");
      return null;
    }
  }

  Future<void> saveUserToken(String? token) async {
    try {
      await _savePref(_userToken, token);
    } catch (e) {
      Log.e("saveUserToken ${e.toString()}");
    }
  }

  Future<bool> getIsLoggedIn() async {
    return await _getPref<bool>(_isLoggedIn) ?? false;
  }

  Future<void> saveIsLoggedIn(bool value) async {
    await _savePref(_isLoggedIn, value);
  }
}
