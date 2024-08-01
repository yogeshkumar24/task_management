import 'package:dio/dio.dart';
import 'package:task_management/profile/data/model/user_model.dart';
import 'package:task_management/shared/api_endpoints.dart';

abstract class ProfileServiceBase {
  Future<List<User>> getAllUsers();

  Future<User> getUser(int id);
}

class ProfileService implements ProfileServiceBase {
  final Dio dio = Dio();

  @override
  Future<List<User>> getAllUsers() async {
    final response = await dio.get(ApiEndpoints.getUsers);
    if (response.statusCode == 200 || response.statusCode == 201) {
      UserModel model = UserModel.fromJson(response.data);
      return model.user!;
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Future<User> getUser(int id) async {
    final response = await dio.get("${ApiEndpoints.getUser}$id");
    if (response.statusCode == 200 || response.statusCode == 201) {
      UserModel2 model = UserModel2.fromJson(response.data);
      return model.user!;
    } else {
      throw Exception("Failed to load");
    }
  }
}
