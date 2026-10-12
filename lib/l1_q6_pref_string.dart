import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 1 — Question 6: Store String value using SharedPreferences & retrieve correctly
class Level1Question6Screen extends StatefulWidget {
  const Level1Question6Screen({super.key});

  @override
  State<Level1Question6Screen> createState() => _Level1Question6ScreenState();
}

class _Level1Question6ScreenState extends State<Level1Question6Screen> {
  final TextEditingController _controller = TextEditingController();
  String _savedValue = 'None';

  @override
  void initState() {
    super.initState();
    _loadSavedString();
  }

  Future<void> _loadSavedString() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedValue = prefs.getString('user_string_key') ?? 'No saved value found';
    });
  }

  Future<void> _saveString() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_string_key', _controller.text);
    _loadSavedString();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('String saved to SharedPreferences!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q6: SharedPreferences String')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter string to save'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveString,
              child: const Text('Save to SharedPreferences'),
            ),
            const SizedBox(height: 30),
            Text(
              'Retrieved Value: $_savedValue',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question6Screen()));
}
