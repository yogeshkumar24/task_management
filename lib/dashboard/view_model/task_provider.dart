import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/dashboard/domain/local_task_repository/local_task_repository.dart';
import 'package:task_management/dashboard/domain/task_repository.dart';
import 'package:task_management/profile/view_model/profile_provider.dart';
import 'package:task_management/shared/log.dart';
import 'package:task_management/shared/util/app_utils.dart';
import 'package:task_management/shared/widget/custom_alert_dialog.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;
  final LocalTaskRepository _localTaskRepository;

  TaskProvider(this._taskRepository, this._localTaskRepository);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<TaskModel> _taskList = [];

  List<TaskModel> get getTaskList => _taskList;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DateTime selectedDate = DateTime.now();
  String? selectedPriority = 'Low';
  String? selectedStatus = "To-Do";
  String? assignedUser;

  Future<void> _fetchTasksFromApi(BuildContext context,
      {bool loading = true}) async {
    _taskList.clear();
    try {
      loading ? isLoading = true : null;
      _taskList = await _taskRepository.getAllTask();
      await _localTaskRepository.saveTasks(_taskList);
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

  Future<void> _loadTasksFromDb() async {
    _taskList.clear();
    try {
      isLoading = true;
      _taskList = await _localTaskRepository.getOfflineTask();
      isLoading = false;
    } catch (e) {
      isLoading = false;
      AppUtils.showToast(e.toString());
    }
  }

  Future<void> fetchTasks(context) async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      await _loadTasksFromDb();
    } else {
      await _fetchTasksFromApi(context);
      getUserData(context);
    }
  }

  getUserData(context) {
    Future.delayed(Duration.zero, () async {
      Provider.of<ProfileProvider>(context, listen: false).getAllUsers(context);
    });
  }

  Future<void> createTask(BuildContext context, TaskModel toDoTask) async {
    try {
      isLoading = true;
      TaskModel task = await _taskRepository.createTask(toDoTask);
      if (task.title != null) {
        _fetchTasksFromApi(context);
        AppUtils.showToast('Task Created', success: true);
        Navigator.of(context).pop();
      }

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

  Future<bool> updateTask(
      BuildContext context, TaskModel toDoTask, String id) async {
    try {
      isLoading = true;
      TaskModel model = await _taskRepository.updateTask(toDoTask, id);
      if (model.sId != null) {
        _fetchTasksFromApi(context, loading: false);
        AppUtils.showToast('Task Updated', success: true);
        return true;
      }

      isLoading = false;
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

  Future<bool> deleteTask(BuildContext context, String id) async {
    Log.d(id);
    try {
      isLoading = true;
      TaskModel model = await _taskRepository.deleteTask(id);
      if (model.sId != null) {
        _fetchTasksFromApi(context);
        AppUtils.showToast('Task Deleted', success: true);
        return true;
      }
      isLoading = false;
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

  setPriority(String value) {
    selectedPriority = value;
    notifyListeners();
  }

  selectStatus(String value) {
    selectedStatus = value;
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  updateUser(value) {
    assignedUser = value;
    notifyListeners();
  }
}
