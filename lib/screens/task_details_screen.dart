import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/providers/task_provider.dart';
import 'package:intl/intl.dart';
import 'package:task_master/screens/add_task_screen.dart';

class TaskDetailsScreen extends ConsumerWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTask(context, ref);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteTask(context, ref);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 8),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(height: 16),
            _buildInfoRow(context, 'Due Date', DateFormat('dd/MM/yyyy').format(task.dueDate)),
            _buildInfoRow(context, 'Priority', task.priority.toString().split('.').last),
            _buildInfoRow(context, 'Status', task.isCompleted ? 'Completed' : 'Pending'),
            SizedBox(height: 16),
            Text('Tags:', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: task.tags
                  .map((tag) => Chip(
                        label: Text(tag),
                      ))
                  .toList(),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(taskProvider.notifier).toggleTaskCompletion(task.id);
                Navigator.of(context).pop();
              },
              child: Text(task.isCompleted ? 'Mark as Incomplete' : 'Mark as Complete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

void _editTask(BuildContext context, WidgetRef ref) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => AddTaskScreen(taskToEdit: task),
    ),
  ).then((_) {
    // Refresh the task details after editing
    final updatedTask = ref.read(taskProvider).firstWhere((t) => t.id == task.id);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TaskDetailsScreen(task: updatedTask),
      ),
    );
  });
}

  void _deleteTask(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}