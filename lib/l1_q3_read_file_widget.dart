import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 3: Read contents of existing file using readAsString() & display in Text widget
Future<String> readFileContent() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/hello.txt');
  if (await file.exists()) {
    return await file.readAsString();
  } else {
    await file.writeAsString('Hello Flutter - Initial File Content!');
    return await file.readAsString();
  }
}

class Level1Question3Screen extends StatefulWidget {
  const Level1Question3Screen({super.key});

  @override
  State<Level1Question3Screen> createState() => _Level1Question3ScreenState();
}

class _Level1Question3ScreenState extends State<Level1Question3Screen> {
  String _fileContent = 'Press button to read file';

  Future<void> _read() async {
    String content = await readFileContent();
    setState(() {
      _fileContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q3: Read File to Text Widget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _read,
              child: const Text('Read File Contents'),
            ),
            const SizedBox(height: 20),
            const Text('File Contents:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _fileContent,
                style: const TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question3Screen()));
}
