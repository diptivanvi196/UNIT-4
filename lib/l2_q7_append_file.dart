import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 7: Function that appends new text to existing file instead of overwriting
Future<void> appendTextToFile(String textToAppend) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/appended_log.txt');
  // Use FileMode.append to append instead of overwriting
  await file.writeAsString('$textToAppend\n', mode: FileMode.append);
}

Future<String> readAppendedFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/appended_log.txt');
  if (await file.exists()) {
    return await file.readAsString();
  }
  return 'File does not exist yet.';
}

class Level2Question7Screen extends StatefulWidget {
  const Level2Question7Screen({super.key});

  @override
  State<Level2Question7Screen> createState() => _Level2Question7ScreenState();
}

class _Level2Question7ScreenState extends State<Level2Question7Screen> {
  final TextEditingController _controller = TextEditingController();
  String _fileContent = '';

  @override
  void initState() {
    super.initState();
    _refreshContent();
  }

  Future<void> _refreshContent() async {
    String content = await readAppendedFile();
    setState(() {
      _fileContent = content;
    });
  }

  Future<void> _handleAppend() async {
    if (_controller.text.trim().isEmpty) return;
    await appendTextToFile(_controller.text.trim());
    _controller.clear();
    await _refreshContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q7: Append Text to File')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter text line to append'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _handleAppend,
              child: const Text('Append Line to File'),
            ),
            const SizedBox(height: 24),
            const Text('Entire File Content:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                color: Colors.grey.shade200,
                child: SingleChildScrollView(
                  child: Text(_fileContent, style: const TextStyle(fontFamily: 'monospace')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question7Screen()));
}
