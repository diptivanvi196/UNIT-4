import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 1: Simple Notes app where note typed by user is saved to & loaded from local file
class Level2Question1Screen extends StatefulWidget {
  const Level2Question1Screen({super.key});

  @override
  State<Level2Question1Screen> createState() => _Level2Question1ScreenState();
}

class _Level2Question1ScreenState extends State<Level2Question1Screen> {
  final TextEditingController _noteController = TextEditingController();
  String _savedNoteText = '';

  @override
  void initState() {
    super.initState();
    _loadNoteFromFile();
  }

  Future<File> _getNoteFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/single_note.txt');
  }

  Future<void> _loadNoteFromFile() async {
    try {
      final file = await _getNoteFile();
      if (await file.exists()) {
        String contents = await file.readAsString();
        setState(() {
          _savedNoteText = contents;
          _noteController.text = contents;
        });
      }
    } catch (e) {
      print('Error loading note: $e');
    }
  }

  Future<void> _saveNoteToFile() async {
    try {
      final file = await _getNoteFile();
      await file.writeAsString(_noteController.text);
      setState(() {
        _savedNoteText = _noteController.text;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved to local file successfully!')),
        );
      }
    } catch (e) {
      print('Error saving note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q1: File Notes App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Type your note here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveNoteToFile,
              icon: const Icon(Icons.save),
              label: const Text('Save Note to File'),
            ),
            const SizedBox(height: 24),
            const Text('Note Loaded From File:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.amber.shade100,
              child: Text(_savedNoteText.isEmpty ? '(No note loaded)' : _savedNoteText),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question1Screen()));
}
