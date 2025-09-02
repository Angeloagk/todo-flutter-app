import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showAboutDialog(
              context: context,
              applicationName: 'To-Do List App',
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2024 Your Company Name',
            );
          },
          child: Text('Show About Dialog'),
        ),
      ),
    );
  }
}
