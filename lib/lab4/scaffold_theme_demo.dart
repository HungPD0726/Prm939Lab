import 'package:flutter/material.dart';

class ScaffoldThemeDemo extends StatelessWidget {
  const ScaffoldThemeDemo({
    super.key,
    required this.isDarkMode,
    required this.fabTaps,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final int fabTaps;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [
        Text('Exercise 4 - Scaffold and Theme', style: textTheme.headlineSmall),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Dark Mode'),
          subtitle: Text(isDarkMode ? 'ThemeMode.dark' : 'ThemeMode.light'),
          value: isDarkMode,
          onChanged: onDarkModeChanged,
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              const ListTile(
                leading: Icon(Icons.web_asset_outlined),
                title: Text('AppBar'),
                subtitle: Text('Top structure for the Lab 4 screen'),
              ),
              const Divider(height: 1),
              const ListTile(
                leading: Icon(Icons.article_outlined),
                title: Text('Body'),
                subtitle: Text('Exercise content is swapped by NavigationBar'),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('FloatingActionButton'),
                subtitle: Text('Tapped $fabTaps time(s)'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
