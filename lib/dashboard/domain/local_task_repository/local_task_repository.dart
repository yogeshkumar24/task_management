import 'package:task_management/dashboard/data/local/database.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';


abstract class LocalTaskRepository {


  Future<List<TaskModel>> getOfflineTask();

  saveTasks(List<TaskModel> tasks);




}

class LocalTaskRepositoryImpl implements LocalTaskRepository {
  final TaskDbService _dbService;

  LocalTaskRepositoryImpl(this._dbService);


  @override
  Future<List<TaskModel>> getOfflineTask() {
    return _dbService.getTasks();
  }



  @override
  saveTasks(List<TaskModel> tasks) {
    _dbService.saveTasks(tasks);
  }
}
