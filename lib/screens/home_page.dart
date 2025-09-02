import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart'; // Your task provider
import 'task_form.dart';
import 'task_details_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Huidige geselecteerde index
  final List<Widget> _pages = []; // Lijst voor pagina's

  @override
  void initState() {
    super.initState();
    // Voeg hier je pagina's toe
    _pages.add(TaskListPage()); // Voeg je taaklijstpagina toe// Voeg een instellingenpagina toe (bijvoorbeeld)

    // Fetch tasks when the HomePage is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      taskProvider.fetchTasks();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Wijzig de geselecteerde index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: _pages[_selectedIndex], // Toon de huidige pagina
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Taken',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Instellingen',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TaskListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return taskProvider.isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: taskProvider.tasks.length,
      itemBuilder: (context, index) {
        final task = taskProvider.tasks[index];
        return ListTile(
          title: Text(task.title),
            subtitle: Text(task.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsPage(taskId: task.id),
              ),
            );
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskForm(task: task),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete Task'),
                        content: Text('Are you sure you want to delete this task?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Delete'),
                          ),
                        ],
                      );
                    },
                  );

                  if (shouldDelete == true) {
                    if (task.id != null) {
                      await taskProvider.deleteTaskFromApi(task.id!);
                    } else {
                      print('Cannot delete: task ID is null');
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


