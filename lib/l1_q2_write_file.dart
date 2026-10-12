import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 2: Create a text file and write "Hello Flutter" into it using writeAsString()
Future<File> writeHelloFlutter() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/hello.txt');
  return await file.writeAsString('Hello Flutter');
}

class Level1Question2Screen extends StatefulWidget {
  const Level1Question2Screen({super.key});

  @override
  State<Level1Question2Screen> createState() => _Level1Question2ScreenState();
}

class _Level1Question2ScreenState extends State<Level1Question2Screen> {
  String _status = 'File not written yet';

  Future<void> _writeToFile() async {
    final file = await writeHelloFlutter();
    setState(() {
      _status = 'Successfully wrote "Hello Flutter" to:\n${file.path}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q2: Write File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _writeToFile,
              child: const Text('Write "Hello Flutter" to File'),
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question2Screen()));
}
