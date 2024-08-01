import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/dashboard/domain/local_task_repository/local_task_repository.dart';
import 'package:task_management/dashboard/domain/task_repository.dart';
import 'package:task_management/shared/log.dart';
import 'package:task_management/shared/util/app_utils.dart';
import 'package:task_management/shared/widget/custom_alert_dialog.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;
  final LocalTaskRepository _localTaskRepository;

  TaskProvider(this._taskRepository, this._localTaskRepository);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dueDateController = TextEditingController();
  final assignController = TextEditingController();

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
    }
  }

  Future<void> createTask(BuildContext context) async {
    try {
      TaskModel newTask = TaskModel(
        title: titleController.text,
        description: descriptionController.text,
        dueDate: dueDateController.text,
        priority: selectedPriority,
        selectedStatus: selectedStatus,
        assignedUser: assignedUser,
      );
      isLoading = true;
      TaskModel task = await _taskRepository.createTask(newTask);
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

  preFillTaskDetails(TaskModel taskModel) {
    titleController.text = taskModel.title ?? "";
    descriptionController.text = taskModel.description ?? "";
    dueDateController.text = taskModel.dueDate!.substring(0, 10);
    assignedUser = taskModel.assignedUser ?? "";
    selectedPriority = taskModel.priority ?? selectedPriority;
    selectedStatus = taskModel.selectedStatus ?? selectedStatus;
  }

  Future<bool> updateTask(BuildContext context, String id) async {
    try {
      TaskModel newTask = TaskModel(
        sId: id,
        title: titleController.text,
        description: descriptionController.text,
        dueDate: dueDateController.text,
        priority: selectedPriority,
        selectedStatus: selectedStatus,
        assignedUser: assignedUser,
      );
      isLoading = true;
      TaskModel model = await _taskRepository.updateTask(newTask, id);
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

  clearField() {
    titleController.clear();
    descriptionController.clear();
    dueDateController.clear();
    assignController.clear();
  }
}
