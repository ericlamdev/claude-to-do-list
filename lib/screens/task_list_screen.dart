import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/providers/task_provider.dart';
import 'package:task_master/screens/add_task_screen.dart';
import 'package:task_master/screens/task_details_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  String _searchQuery = '';

  List<Task> _filterTasks(List<Task> tasks) {
    if (_searchQuery.isEmpty) {
      return tasks;
    }
    return tasks
        .where((task) =>
            task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            task.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final filteredTasks = _filterTasks(tasks);

    return Scaffold(
      appBar: AppBar(
        title: Text('TaskMaster'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => AddTaskScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredTasks.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (task.tags.isNotEmpty)
                          Wrap(
                            spacing: 4,
                            children: task.tags
                                .map((tag) => Chip(
                                      label: Text(tag, style: TextStyle(fontSize: 10)),
                                      padding: EdgeInsets.all(4),
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            task.isCompleted
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: task.isCompleted ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            ref
                                .read(taskProvider.notifier)
                                .toggleTaskCompletion(task.id);
                          },
                        ),
                        Icon(_getPriorityIcon(task.priority),
                            color: _getPriorityColor(task.priority)),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TaskDetailsScreen(task: task),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Icons.low_priority;
      case Priority.medium:
        return Icons.priority_high;
      case Priority.high:
        return Icons.error;
    }
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }
}
