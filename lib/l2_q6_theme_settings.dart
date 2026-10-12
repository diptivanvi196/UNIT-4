import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 2 — Question 6: Settings screen that saves theme preference (dark/light) using SharedPreferences
class Level2Question6Screen extends StatefulWidget {
  const Level2Question6Screen({super.key});

  @override
  State<Level2Question6Screen> createState() => _Level2Question6ScreenState();
}

class _Level2Question6ScreenState extends State<Level2Question6Screen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('is_dark_theme') ?? false;
    });
  }

  Future<void> _toggleTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_theme', value);
    setState(() {
      _isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(title: const Text('L2 Q6: Theme Settings')),
        body: Center(
          child: Card(
            margin: const EdgeInsets.all(20),
            child: SwitchListTile(
              title: const Text('Dark Mode Preference'),
              subtitle: Text(_isDarkMode ? 'Current: Dark Theme' : 'Current: Light Theme'),
              value: _isDarkMode,
              onChanged: _toggleTheme,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const Level2Question6Screen());
}
