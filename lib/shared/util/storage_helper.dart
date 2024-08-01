import 'package:get_storage/get_storage.dart';
import 'package:task_management/shared/log.dart';

class StorageHelper {
  static const String _userId = "userId";
  static const String _userToken = "userToken";
  static const String _isLoggedIn = "isLogin";
  static final StorageHelper _singleton = StorageHelper._internal();

  StorageHelper._internal();

  static Future init() async {
    await GetStorage.init();
  }

  factory StorageHelper() {
    return _singleton;
  }

  _savePref(String key, Object? value) async {
    var prefs = GetStorage();
    prefs.write(key, value);
  }

  T _getPref<T>(String key) {
    return GetStorage().read(key) as T;
  }

  void clearAll() {
    GetStorage().erase();
  }

  String? getUserId() {
    return _getPref(_userId);
  }

  void saveUserId(String? id) {
    _savePref(_userId, id);
  }

  String? getUserToken() {
    try {
      return _getPref(_userToken);
    } catch (e) {
      Log.e("getUserToken ${e.toString()}");
    }
  }

  void saveUserToken(String? token) {
    try {
      _savePref(_userToken, token);
    } catch (e) {
      Log.e("saveUserToken ${e.toString()}");
    }
  }

  bool getIsLoggedIn() {
    return _getPref(_isLoggedIn) ?? false;
  }

  void saveIsLoggedIn(bool value) {
    _savePref(_isLoggedIn, value);
  }
}
