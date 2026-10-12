import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 1: Print Application Documents Directory path
Future<String> printAppDocDir() async {
  Directory dir = await getApplicationDocumentsDirectory();
  print('App Documents Directory Path: ${dir.path}');
  return dir.path;
}

class Level1Question1Screen extends StatefulWidget {
  const Level1Question1Screen({super.key});

  @override
  State<Level1Question1Screen> createState() => _Level1Question1ScreenState();
}

class _Level1Question1ScreenState extends State<Level1Question1Screen> {
  String _path = 'Click button to get directory path';

  Future<void> _getDirectory() async {
    String path = await printAppDocDir();
    setState(() {
      _path = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q1: App Doc Directory')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _getDirectory,
              child: const Text('Get App Documents Directory Path'),
            ),
            const SizedBox(height: 20),
            SelectableText(
              _path,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question1Screen()));
}
