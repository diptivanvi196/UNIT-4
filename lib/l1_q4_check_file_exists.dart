import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 4: Check whether file exists using exists() before reading
Future<String> checkAndReadFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');

  bool isExist = await file.exists();
  if (isExist) {
    String content = await file.readAsString();
    return 'File EXISTS! Contents: "$content"';
  } else {
    return 'File "$filename" does NOT exist in directory.';
  }
}

class Level1Question4Screen extends StatefulWidget {
  const Level1Question4Screen({super.key});

  @override
  State<Level1Question4Screen> createState() => _Level1Question4ScreenState();
}

class _Level1Question4ScreenState extends State<Level1Question4Screen> {
  String _result = 'Click below to check file existence';

  Future<void> _checkExisting() async {
    String res = await checkAndReadFile('hello.txt');
    setState(() {
      _result = res;
    });
  }

  Future<void> _checkNonExisting() async {
    String res = await checkAndReadFile('non_existent.txt');
    setState(() {
      _result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q4: Check File Exists')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _checkExisting,
              child: const Text('Check "hello.txt"'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _checkNonExisting,
              child: const Text('Check "non_existent.txt"'),
            ),
            const SizedBox(height: 20),
            Text(_result, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question4Screen()));
}
