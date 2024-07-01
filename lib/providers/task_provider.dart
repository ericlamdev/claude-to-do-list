import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/services/storage_service.dart';

class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await StorageService.getTasks();
    state = tasks;
  }

  Future<void> addTask(Task task) async {
    await StorageService.addTask(task);
    state = [...state, task];
  }

  Future<void> updateTask(Task task) async {
    await StorageService.updateTask(task);
    state = [
      for (final t in state)
        if (t.id == task.id) task else t
    ];
  }

  Future<void> deleteTask(String id) async {
    await StorageService.deleteTask(id);
    state = state.where((task) => task.id != id).toList();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final taskIndex = state.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      final updatedTask = state[taskIndex].copyWith(isCompleted: !state[taskIndex].isCompleted);
      await updateTask(updatedTask);
    }
  }
}

final taskProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  return TaskNotifier();
});