import 'package:task_management/profile/data/model/user_model.dart';
import 'package:task_management/profile/data/profile_service.dart';

abstract class ProfileRepository {
  Future<List<User>> getAllUsers();

  Future<User> getUser(int id);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileService _profileService;

  ProfileRepositoryImpl(this._profileService);

  @override
  Future<List<User>> getAllUsers() {
    return _profileService.getAllUsers();
  }

  @override
  Future<User> getUser(int id) {
    return _profileService.getUser(id);
  }
}
