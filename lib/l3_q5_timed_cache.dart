import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 3 — Question 5: Caching system with 5-minute expiry timestamp
class CachedPayload {
  final String data;
  final DateTime timestamp;

  CachedPayload({required this.data, required this.timestamp});

  bool isExpired({Duration timeout = const Duration(minutes: 5)}) {
    return DateTime.now().difference(timestamp) > timeout;
  }
}

class TimedCacheSystem {
  CachedPayload? _cachedPayload;

  Future<String> getData() async {
    if (_cachedPayload != null && !_cachedPayload!.isExpired()) {
      print('TIMED CACHE HIT (Age: ${DateTime.now().difference(_cachedPayload!.timestamp).inSeconds}s)');
      return 'Cache Hit: ${_cachedPayload!.data}';
    }

    print('TIMED CACHE EXPIRED OR ABSENT. Re-fetching from Network API...');
    await Future.delayed(const Duration(seconds: 1)); // Network latency
    String freshData = 'Fresh API Data @ ${DateTime.now().toIso8601String()}';

    _cachedPayload = CachedPayload(
      data: freshData,
      timestamp: DateTime.now(),
    );

    return 'Network Fetch: $freshData';
  }
}

class Level3Question5Screen extends StatefulWidget {
  const Level3Question5Screen({super.key});

  @override
  State<Level3Question5Screen> createState() => _Level3Question5ScreenState();
}

class _Level3Question5ScreenState extends State<Level3Question5Screen> {
  final TimedCacheSystem _cacheSystem = TimedCacheSystem();
  String _resultText = 'Press button to load timed data';

  Future<void> _fetch() async {
    String res = await _cacheSystem.getData();
    setState(() {
      _resultText = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q5: Timed Expiry Cache (5 mins)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _fetch, child: const Text('Request Data')),
            const SizedBox(height: 20),
            Text(_resultText, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question5Screen()));
}
