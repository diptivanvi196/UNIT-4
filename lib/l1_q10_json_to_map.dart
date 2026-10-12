import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 1 — Question 10: Convert JSON string back into Dart Map using jsonDecode() & print
Map<String, dynamic> convertJsonToMap(String jsonStr) {
  return jsonDecode(jsonStr) as Map<String, dynamic>;
}

class Level1Question10Screen extends StatelessWidget {
  const Level1Question10Screen({super.key});

  @override
  Widget build(BuildContext context) {
    const String jsonInput = '{"title": "Flutter Basics", "version": 3.13, "published": true}';
    final Map<String, dynamic> resultMap = convertJsonToMap(jsonInput);

    // Printing values to console as requested
    resultMap.forEach((key, value) {
      print('Key: $key -> Value: $value');
    });

    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q10: JSON String to Map')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('JSON Input String:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(jsonInput, style: const TextStyle(color: Colors.deepOrange)),
            const SizedBox(height: 20),
            const Text('Decoded Map Keys & Values:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...resultMap.entries.map((entry) => ListTile(
                  title: Text(entry.key),
                  subtitle: Text('${entry.value} (${entry.value.runtimeType})'),
                )),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question10Screen()));
}
