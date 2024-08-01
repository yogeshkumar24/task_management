import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/dashboard/data/task_service.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTask();

  Future<TaskModel> createTask(TaskModel task);

  Future<TaskModel> updateTask(TaskModel task, String id);

  Future<TaskModel> deleteTask(String id);
}

class TaskRepositoryImpl implements TaskRepository {
  final TaskService _taskService;

  TaskRepositoryImpl(this._taskService);

  @override
  Future<List<TaskModel>> getAllTask() {
    return _taskService.getAllTask();
  }

  @override
  Future<TaskModel> createTask(TaskModel task) {
    return _taskService.createTask(task);
  }

  @override
  Future<TaskModel> updateTask(TaskModel task, String id) {
    return _taskService.updateTask(task, id);
  }

  @override
  Future<TaskModel> deleteTask(String id) {
    return _taskService.deleteTask(id);
  }
}
