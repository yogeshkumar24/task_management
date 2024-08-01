import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/shared/api_endpoints.dart';
import '../../shared/log.dart';

abstract class TaskServiceBase {
  Future<List<TaskModel>> getAllTask();

  Future<TaskModel> createTask(TaskModel task);

  Future<TaskModel> updateTask(TaskModel task, String id);

  Future<TaskModel> deleteTask(String id);
}

class TaskService implements TaskServiceBase {
  final Dio dio = Dio();

  @override
  Future<List<TaskModel>> getAllTask() async {
    final response = await dio.get(ApiEndpoints.getTasks);
    Log.d(response.toString());
    if (response.statusCode == 200) {
      List<TaskModel> taskList = [];
      for (var data in response.data) {
        taskList.add(TaskModel.fromJson(data));
      }
      return taskList;
    } else {
      throw Exception("Failed to login");
    }
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final response = await dio.post(ApiEndpoints.createTasks,
        data: jsonEncode(task.toJson()),
        options: Options(
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
          },
        ));
    Log.d(response.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return TaskModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Future<TaskModel> updateTask(TaskModel task, String id) async {
    final response = await dio.patch("${ApiEndpoints.updateTask}$id",
        data: jsonEncode(task.toJson()),
        options: Options(
          headers: {
            'Content-type': 'application/json',
          },
        ));

    Log.d(response.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return TaskModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load data");
    }
  }

  @override
  Future<TaskModel> deleteTask(String id) async {
    Log.i(id);
    final response = await dio.delete(
      "${ApiEndpoints.deleteTask}$id",
    );
    Log.d(response.toString());
    if (response.statusCode == 200 || response.statusCode == 201) {
      return TaskModel.fromJson(response.data);
    } else {
      throw Exception("Failed to delete");
    }
  }
}
