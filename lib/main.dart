import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/auth/data/auth_service.dart';
import 'package:task_management/auth/domain/auth_repository.dart';
import 'package:task_management/auth/ui/screen/sign_up.dart';
import 'package:task_management/auth/view_model/auth_provider.dart';
import 'package:task_management/dashboard/data/local/database.dart';
import 'package:task_management/dashboard/data/task_service.dart';
import 'package:task_management/dashboard/domain/local_task_repository/local_task_repository.dart';
import 'package:task_management/dashboard/domain/task_repository.dart';
import 'package:task_management/dashboard/ui/dashboard.dart';
import 'package:task_management/dashboard/view_model/task_provider.dart';
import 'package:task_management/profile/data/profile_service.dart';
import 'package:task_management/profile/domain/profile_repository.dart';
import 'package:task_management/profile/view_model/profile_provider.dart';
import 'package:task_management/shared/util/storage_helper.dart';

void main() {
  setUp();
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  StorageHelper.init();
  await TaskDbService().initDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    StorageHelper? helper = StorageHelper();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(UserRepositoryImpl(AuthService())),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider(TaskRepositoryImpl(TaskService()),
              LocalTaskRepositoryImpl(TaskDbService())),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProfileProvider(ProfileRepositoryImpl(ProfileService())),
        )
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: helper.getIsLoggedIn()
              ? const Dashboard()
              : const RegisterScreen()),
    );
  }
}
