import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/auth/domain/auth_repository.dart';
import 'package:task_management/auth/ui/screen/sign_up.dart';
import 'package:task_management/auth/view_model/auth_provider.dart';
import 'package:task_management/dashboard/data/local/database.dart';
import 'package:task_management/dashboard/domain/local_task_repository/local_task_repository.dart';
import 'package:task_management/dashboard/domain/task_repository.dart';
import 'package:task_management/dashboard/ui/dashboard.dart';
import 'package:task_management/dashboard/view_model/task_provider.dart';
import 'package:task_management/profile/domain/profile_repository.dart';
import 'package:task_management/profile/view_model/profile_provider.dart';
import 'package:task_management/shared/util/storage_helper.dart';
import 'package:task_management/dependency/get_it.dart' as it;

void main() {
  setUp();
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  it.setupLocator();
  await TaskDbService().initDatabase();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AuthProvider(it.getIt<UserRepositoryImpl>()),
          ),
          ChangeNotifierProvider(
            create: (context) => TaskProvider(it.getIt<TaskRepositoryImpl>(),
                it.getIt<LocalTaskRepositoryImpl>()),
          ),
          ChangeNotifierProvider(
            create: (context) =>
                ProfileProvider(it.getIt<ProfileRepositoryImpl>()),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: FutureBuilder<bool>(
              future: it.getIt<StorageHelper>().getIsLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  bool isLoggedIn = snapshot.data ?? false;
                  return isLoggedIn ? const Dashboard() : RegisterScreen();
                }
              },
            )));
  }
}
