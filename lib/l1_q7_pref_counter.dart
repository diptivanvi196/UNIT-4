import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 1 — Question 7: Store integer counter using SharedPreferences & increment on button press
class Level1Question7Screen extends StatefulWidget {
  const Level1Question7Screen({super.key});

  @override
  State<Level1Question7Screen> createState() => _Level1Question7ScreenState();
}

class _Level1Question7ScreenState extends State<Level1Question7Screen> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter_key') ?? 0;
    });
  }

  Future<void> _incrementCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int newCount = _counter + 1;
    await prefs.setInt('counter_key', newCount);
    setState(() {
      _counter = newCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q7: Persisted Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Counter Value (Persisted):', style: TextStyle(fontSize: 18)),
            Text('$_counter', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _incrementCounter,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question7Screen()));
}
