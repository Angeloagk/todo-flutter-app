import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Dark Mode'),
              trailing: Switch(
                value: settingsProvider.isDarkMode,
                onChanged: (value) {
                  settingsProvider.toggleDarkMode();
                },
              ),
            ),
            // Hier kun je meer instellingen toevoegen als dat nodig is
          ],
        ),
      ),
    );
  }
}
