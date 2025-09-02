import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/to_do_service.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final RemoteService _remoteService = RemoteService();
  late Future<List<Task>> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = _remoteService.getTasks();
  }

  Future<void> _refreshTasks() async {
    setState(() {
      _tasks = _remoteService.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: FutureBuilder<List<Task>>(
        future: _tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return Center(child: Text('No tasks found'));
          }

          return RefreshIndicator(
            onRefresh: _refreshTasks,
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // TODO: Voeg update functionaliteit toe
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _remoteService.deleteTask(task.id);
                          _refreshTasks();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
