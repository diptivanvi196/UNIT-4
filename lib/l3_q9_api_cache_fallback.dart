import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 9: Download JSON from API, cache locally, fallback to cache on network failure
class Level3Question9Screen extends StatefulWidget {
  const Level3Question9Screen({super.key});

  @override
  State<Level3Question9Screen> createState() => _Level3Question9ScreenState();
}

class _Level3Question9ScreenState extends State<Level3Question9Screen> {
  String _status = 'Press button to load data';
  String _jsonContent = '';
  bool _isLoading = false;

  Future<File> _getCacheFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/api_cached_posts.json');
  }

  Future<void> _fetchWithFallback() async {
    setState(() => _isLoading = true);
    final cacheFile = await _getCacheFile();
    const apiUrl = 'https://jsonplaceholder.typicode.com/posts/2';

    try {
      // 1. Attempt Network Fetch
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        // Save fresh copy locally
        await cacheFile.writeAsString(response.body);
        setState(() {
          _status = 'Successfully fetched from Network API & cached locally!';
          _jsonContent = response.body;
          _isLoading = false;
        });
        return;
      }
      throw Exception('Server returned ${response.statusCode}');
    } catch (e) {
      // 2. Fallback to cached copy on failure
      if (await cacheFile.exists()) {
        String cachedData = await cacheFile.readAsString();
        setState(() {
          _status = 'Network request failed ($e).\nFalling back to Local Cached Copy!';
          _jsonContent = cachedData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _status = 'Network failed and no local cached copy available.';
          _jsonContent = '';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q9: API Cache Fallback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _fetchWithFallback, child: const Text('Fetch Data (Network with Fallback)')),
            const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
            Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(_jsonContent, style: const TextStyle(fontFamily: 'monospace')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question9Screen()));
}
