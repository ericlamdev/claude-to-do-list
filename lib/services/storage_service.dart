import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_master/models/task.dart';

class StorageService {
  static const String _tasksBoxName = 'tasks';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(PriorityAdapter());
    await Hive.openBox<Task>(_tasksBoxName);
  }

  static Box<Task> _getTasksBox() {
    return Hive.box<Task>(_tasksBoxName);
  }

  static Future<List<Task>> getTasks() async {
    final box = _getTasksBox();
    return box.values.toList();
  }

  static Future<void> addTask(Task task) async {
    final box = _getTasksBox();
    await box.put(task.id, task);
  }

  static Future<void> updateTask(Task task) async {
    final box = _getTasksBox();
    await box.put(task.id, task);
  }

  static Future<void> deleteTask(String id) async {
    final box = _getTasksBox();
    await box.delete(id);
  }
}