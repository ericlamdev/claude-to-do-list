import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_master/models/task.dart';
import 'package:task_master/providers/task_provider.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  final Task? taskToEdit;

  AddTaskScreen({this.taskToEdit});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late DateTime _dueDate;
  late Priority _priority;
  List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _title = widget.taskToEdit!.title;
      _description = widget.taskToEdit!.description;
      _dueDate = widget.taskToEdit!.dueDate;
      _priority = widget.taskToEdit!.priority;
      _tags = List.from(widget.taskToEdit!.tags);
    } else {
      _title = '';
      _description = '';
      _dueDate = DateTime.now();
      _priority = Priority.low;
    }
  }

  void _addTag() {
    if (_tagController.text.isNotEmpty) {
      setState(() {
        _tags.add(_tagController.text);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        id: widget.taskToEdit?.id ?? DateTime.now().toString(),
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        isCompleted: widget.taskToEdit?.isCompleted ?? false,
        tags: _tags,
      );

      if (widget.taskToEdit != null) {
        ref.read(taskProvider.notifier).updateTask(task);
      } else {
        ref.read(taskProvider.notifier).addTask(task);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.taskToEdit != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              initialValue: _title,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            TextFormField(
              initialValue: _description,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onSaved: (value) => _description = value ?? '',
            ),
            ListTile(
              title: Text('Due Date'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(_dueDate)),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                );
                if (pickedDate != null) {
                  setState(() {
                    _dueDate = pickedDate;
                  });
                }
              },
            ),
            DropdownButtonFormField<Priority>(
              value: _priority,
              decoration: InputDecoration(labelText: 'Priority'),
              items: Priority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text('Tags', style: Theme.of(context).textTheme.titleMedium),
            Wrap(
              spacing: 8,
              children: _tags
                  .map((tag) => Chip(
                        label: Text(tag),
                        onDeleted: () => _removeTag(tag),
                      ))
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagController,
                    decoration: InputDecoration(
                      hintText: 'Add a tag',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTag,
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.taskToEdit != null ? 'Update Task' : 'Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}