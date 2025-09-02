import 'package:flutter/material.dart';
import 'package:to_do_list/screens/task_form.dart';
import 'package:to_do_list/screens/task_details_page.dart';

class AppRoutes {
  static const String taskForm = '/task-form';
  static const String taskDetails = '/task-details';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case taskForm:
        return MaterialPageRoute(builder: (_) => TaskForm());

      case taskDetails:
      // Ensure taskId is passed as an int and cast it properly
        final int taskId = settings.arguments as int; // Cast arguments to int
        return MaterialPageRoute(builder: (_) => TaskDetailsPage(taskId: taskId));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
