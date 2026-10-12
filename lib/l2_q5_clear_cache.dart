import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 2 — Question 5: Implement "Clear Cache" button emptying cache Map & forcing fresh fetch
class CacheManager {
  final Map<String, String> cacheMap = {};

  Future<String> getData(String key) async {
    if (cacheMap.containsKey(key)) {
      return '[CACHE] ${cacheMap[key]}';
    }
    // Simulate network fetch
    await Future.delayed(const Duration(seconds: 1));
    String freshData = 'Fresh Item Data for "$key" @ ${DateTime.now().second}s';
    cacheMap[key] = freshData;
    return '[NETWORK] $freshData';
  }

  void clearCache() {
    cacheMap.clear();
  }
}

class Level2Question5Screen extends StatefulWidget {
  const Level2Question5Screen({super.key});

  @override
  State<Level2Question5Screen> createState() => _Level2Question5ScreenState();
}

class _Level2Question5ScreenState extends State<Level2Question5Screen> {
  final CacheManager _manager = CacheManager();
  String _display = 'Click Fetch to get data';

  Future<void> _fetch() async {
    String res = await _manager.getData('item_1');
    setState(() {
      _display = res;
    });
  }

  void _clear() {
    _manager.clearCache();
    setState(() {
      _display = 'Cache emptied! Next fetch will be fresh from Network.';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q5: Clear Cache Button')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _fetch, child: const Text('Fetch Data')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                  onPressed: _clear,
                  child: const Text('Clear Cache'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(_display, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question5Screen()));
}
