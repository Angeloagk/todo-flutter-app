import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

const String baseUrl = 'http://10.0.2.2:8000/api';

class RemoteService {
  // Fetch all tasks
  Future<List<Task>> getTasks() async {
    try {
      final url = Uri.parse('$baseUrl/tasks');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  // Add a task
  Future<void> addTask(Task task) async {
    final url = Uri.parse('$baseUrl/tasks');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add task');
      }
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  // Update a task
  Future<void> updateTask(Task task) async {
    final url = Uri.parse('$baseUrl/tasks/${task.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update task');
      }
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(int? id) async {
    if (id == null) return;
    final url = Uri.parse('$baseUrl/tasks/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode != 204) {
        throw Exception('Failed to delete task');
      }
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
