import 'package:flutter/material.dart';
import '../providers/task_provider.dart';
import '../navigation//app_routes.dart'; // Zorg ervoor dat je de juiste import hebt
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.taskDetails,
              arguments: task.id, // Geef de task.id als argument door
            );
          },
        );
      },
    );
  }
}
