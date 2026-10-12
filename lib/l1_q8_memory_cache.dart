import 'package:flutter/material.dart';

/// Level 1 — Question 8: Simple in-memory cache using Map to store & reuse API response data
class MemoryCacheService {
  final Map<String, String> _cache = {};

  Future<String> fetchData(String key) async {
    if (_cache.containsKey(key)) {
      print('CACHE HIT for key: $key');
      return 'Cached Data [From Memory]: ${_cache[key]}';
    }

    print('CACHE MISS for key: $key. Simulating API call...');
    await Future.delayed(const Duration(seconds: 2));
    String apiData = 'API Result for "$key" at ${DateTime.now().second}s';
    _cache[key] = apiData;
    return 'Fetched Data [From API]: $apiData';
  }

  void clearCache() {
    _cache.clear();
  }
}

class Level1Question8Screen extends StatefulWidget {
  const Level1Question8Screen({super.key});

  @override
  State<Level1Question8Screen> createState() => _Level1Question8ScreenState();
}

class _Level1Question8ScreenState extends State<Level1Question8Screen> {
  final MemoryCacheService _cacheService = MemoryCacheService();
  String _displayResult = 'No data loaded';
  bool _isLoading = false;

  Future<void> _loadData(String key) async {
    setState(() => _isLoading = true);
    String result = await _cacheService.fetchData(key);
    setState(() {
      _displayResult = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q8: Memory Cache Map')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _loadData('user_profile'),
              child: const Text('Fetch "user_profile"'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _loadData('app_config'),
              child: const Text('Fetch "app_config"'),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Text(_displayResult, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question8Screen()));
}
