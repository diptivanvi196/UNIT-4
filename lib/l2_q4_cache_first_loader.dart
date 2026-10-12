import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Level 2 — Question 4: Cache-first data loader checking memory cache before API http request
class CacheFirstDataLoader {
  static final Map<String, dynamic> _memoryCache = {};

  static Future<dynamic> getData(String url) async {
    // 1. Check memory cache first
    if (_memoryCache.containsKey(url)) {
      print('CACHE HIT for $url');
      return {'data': _memoryCache[url], 'source': 'Memory Cache'};
    }

    // 2. Fallback to Network API
    print('CACHE MISS for $url. Calling Network API...');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      _memoryCache[url] = jsonResult; // save to cache
      return {'data': jsonResult, 'source': 'Network API'};
    } else {
      throw Exception('Failed to load API data');
    }
  }
}

class Level2Question4Screen extends StatefulWidget {
  const Level2Question4Screen({super.key});

  @override
  State<Level2Question4Screen> createState() => _Level2Question4ScreenState();
}

class _Level2Question4ScreenState extends State<Level2Question4Screen> {
  String _status = 'Press button to load data';
  String _dataOutput = '';
  bool _loading = false;

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    const apiUrl = 'https://jsonplaceholder.typicode.com/posts/1';
    try {
      final result = await CacheFirstDataLoader.getData(apiUrl);
      setState(() {
        _status = 'Loaded from: ${result['source']}';
        _dataOutput = jsonEncode(result['data']);
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error loading data: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q4: Cache-First Data Loader')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Fetch Post Data'),
            ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            Text(_status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            SelectableText(_dataOutput),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question4Screen()));
}
