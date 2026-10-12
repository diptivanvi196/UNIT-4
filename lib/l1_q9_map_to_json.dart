import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 1 — Question 9: Convert simple Dart Map into JSON string using jsonEncode()
String convertMapToJson(Map<String, dynamic> data) {
  return jsonEncode(data);
}

class Level1Question9Screen extends StatelessWidget {
  const Level1Question9Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userMap = {
      'name': 'Dipti',
      'age': 22,
      'isStudent': true,
      'skills': ['Dart', 'Flutter']
    };

    final String jsonString = convertMapToJson(userMap);

    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q9: Map to JSON String')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Original Map:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text('$userMap'),
            const SizedBox(height: 20),
            const Text('Encoded JSON String (jsonEncode):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.grey.shade200,
              child: SelectableText(jsonString, style: const TextStyle(fontFamily: 'monospace', color: Colors.indigo)),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question9Screen()));
}
