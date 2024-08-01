import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:task_management/dashboard/data/model/task_model.dart';
import 'package:task_management/shared/log.dart';

class TaskDbService {
  static const databaseName = 'task_database.db';
  static const taskTableName = 'tasks';

  // Singleton instance
  static final TaskDbService _instance = TaskDbService._internal();

  factory TaskDbService() => _instance;

  TaskDbService._internal();

  // Completer to manage initialization state
  final Completer<Database> _dbCompleter = Completer<Database>();

  Future<Database> get _database async {
    return _dbCompleter.future;
  }

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), databaseName);
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
    _dbCompleter.complete(database);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $taskTableName(
      id TEXT,
      title TEXT,
      description TEXT,
      dueDate TEXT,
      priority TEXT,
      selectedStatus TEXT,
      assignedUser TEXT
    )
  ''');
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await _database;
    List<Map<String, dynamic>> taskMaps = await db.query(taskTableName);
    return taskMaps.map((taskMap) {
      return TaskModel(
        sId: taskMap['id'],
        title: taskMap['title'],
        description: taskMap['description'],
        dueDate: taskMap['dueDate'],
        selectedStatus: taskMap['selectedStatus'],
        assignedUser: taskMap['assignedUser'],
      );
    }).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final db = await _database;
    try {
      await db.delete(taskTableName);
      Batch batch = db.batch();
      for (final task in tasks) {
        batch.insert(
          taskTableName,
          {
            'id': task.sId,
            'title': task.title,
            'description': task.description,
            'dueDate': task.dueDate,
            'priority': task.priority,
            'selectedStatus': task.selectedStatus,
            'assignedUser': task.assignedUser,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit();
    } catch (e) {
      Log.e('saveTasks: $e');
    }
  }
}
