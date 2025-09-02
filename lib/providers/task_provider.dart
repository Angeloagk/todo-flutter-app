import 'package:flutter/material.dart';
import '../models/task.dart'; // Ensure you have a Task model
import 'package:http/http.dart' as http;
import 'dart:convert';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // Fetch tasks from the API
  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
      await http.get(Uri.parse('http://10.0.2.2:8000/api/tasks'));

      if (response.statusCode == 200) {
        final List<dynamic> taskJson = json.decode(response.body);
        _tasks = taskJson.map((json) => Task.fromJson(json)).toList();
      } else {
        print('Failed to load tasks: ${response.body}');
        throw Exception('Failed to load tasks');
      }
    } catch (error) {
      print('Error fetching tasks: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a task to the API
  Future<void> addTaskToApi(Task task) async {
    final url = Uri.parse('http://10.0.2.2:8000/api/tasks');

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':
          'Bearer 8|NfE5jSDdUoENxzBZ9oL3SLASpRrtBg0ipAPGElV08b9abdce',
        },
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'is_completed': false,
        }),
      );

      if (response.statusCode == 201) {
        _tasks.add(Task.fromJson(json.decode(response.body))); // Add the newly created task
        notifyListeners();
      } else {
        print('Failed to add task: ${response.body}');
      }
    } catch (error) {
      print('Error adding task: $error');
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    final url = 'http://10.0.2.2:8000/api/tasks/${updatedTask.id}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
          'Bearer 8|NfE5jSDdUoENxzBZ9oL3SLASpRrtBg0ipAPGElV08b9abdce',
        },
        body: jsonEncode({
          'id': updatedTask.id,
          'title': updatedTask.title,
          'description': updatedTask.description,
          'is_completed': updatedTask.isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        // Update the local tasks list if the update was successful
        final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
        if (index != -1) {
          _tasks[index] = updatedTask; // Update the existing task in the list
          notifyListeners();
        }
      } else {
        print("Failed to update task: ${response.body}");
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  // Delete a task from the API
  Future<void> deleteTaskFromApi(int taskId) async {
    var url = Uri.parse('http://10.0.2.2:8000/api/tasks/$taskId');

    try {
      var response = await http.delete(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
        'Bearer 8|NfE5jSDdUoENxzBZ9oL3SLASpRrtBg0ipAPGElV08b9abdce',
      });

      if (response.statusCode == 204) {
        // Expecting 204 No Content
        _tasks.removeWhere((task) => task.id == taskId);
        notifyListeners();
      } else {
        print('Failed to delete task: ${response.body}');
      }
    } catch (error) {
      print('Error deleting task: $error');
    }
  }
}
