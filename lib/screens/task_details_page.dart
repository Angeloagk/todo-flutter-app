import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskDetailsPage extends StatefulWidget {
  final int? taskId; // Received as int

  TaskDetailsPage({required this.taskId});

  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late Task _task; // Task instance for editing
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _task = taskProvider.tasks.firstWhere((task) => task.id == widget.taskId);
    _titleController = TextEditingController(text: _task.title);
    _descriptionController = TextEditingController(text: _task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Updated _updateTask method
  Future<void> _updateTask() async {
    final updatedTask = Task(
      id: _task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: _task.isCompleted, // Keep the original completion status
    );

    // Call the provider's update method to update the task
    await Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
    Navigator.pop(context); // Go back after update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateTask, // Call the _updateTask method when pressed
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 10),
            Text('Completed: ${_task.isCompleted ? "Yes" : "No"}'),
          ],
        ),
      ),
    );
  }
}
