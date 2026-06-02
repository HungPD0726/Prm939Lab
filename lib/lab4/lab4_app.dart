import 'package:flutter/material.dart';

import 'ex1.dart';
import 'ex2.dart';
import 'ex3.dart';
import 'ex4.dart';
import 'ex5.dart';

class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  @override
  State<Lab4App> createState() => _Lab4AppState();
}

class _Lab4AppState extends State<Lab4App> {
  ThemeMode _themeMode = ThemeMode.light;

  void _setDarkMode(bool enabled) {
    setState(() {
      _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = _themeMode == ThemeMode.dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 4 - Flutter UI Fundamentals',
      // ThemeMode is controlled by the dark mode toggle in Exercise 4.
      themeMode: _themeMode,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      home: Lab4HomeScreen(
        isDarkMode: isDarkMode,
        onDarkModeChanged: _setDarkMode,
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.teal,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
    );
  }
}

class Lab4HomeScreen extends StatefulWidget {
  const Lab4HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onDarkModeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onDarkModeChanged;

  @override
  State<Lab4HomeScreen> createState() => _Lab4HomeScreenState();
}

class _Lab4HomeScreenState extends State<Lab4HomeScreen> {
  int _selectedIndex = 0;
  int _fabTaps = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const CoreWidgetsDemo(),
      const InputControlsDemo(),
      const LayoutBasicsDemo(),
      ScaffoldThemeDemo(
        isDarkMode: widget.isDarkMode,
        fabTaps: _fabTaps,
        onDarkModeChanged: widget.onDarkModeChanged,
      ),
      const DebugFixesDemo(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4'),
        actions: [
          Tooltip(
            message: widget.isDarkMode ? 'Light mode' : 'Dark mode',
            child: Switch(
              value: widget.isDarkMode,
              onChanged: widget.onDarkModeChanged,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: _selectedIndex, children: pages),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            _fabTaps++;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('FAB tapped $_fabTaps time(s)')),
          );
        },
        icon: const Icon(Icons.add),
        label: Text('FAB $_fabTaps'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            label: 'Core',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune_outlined),
            label: 'Input',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_agenda_outlined),
            label: 'Layout',
          ),
          NavigationDestination(
            icon: Icon(Icons.web_asset_outlined),
            label: 'Scaffold',
          ),
          NavigationDestination(
            icon: Icon(Icons.bug_report_outlined),
            label: 'Fixes',
          ),
        ],
      ),
    );
  }
}
