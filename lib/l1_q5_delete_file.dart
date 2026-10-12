import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 1 — Question 5: Delete a file using file.delete() and show confirmation
Future<bool> deleteLocalFile(String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$filename');
  if (await file.exists()) {
    await file.delete();
    return true;
  }
  return false;
}

class Level1Question5Screen extends StatefulWidget {
  const Level1Question5Screen({super.key});

  @override
  State<Level1Question5Screen> createState() => _Level1Question5ScreenState();
}

class _Level1Question5ScreenState extends State<Level1Question5Screen> {
  Future<void> _createDummyFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/temp_to_delete.txt');
    await file.writeAsString('This file will be deleted');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Created "temp_to_delete.txt"')),
      );
    }
  }

  Future<void> _handleDelete() async {
    bool deleted = await deleteLocalFile('temp_to_delete.txt');
    if (mounted) {
      if (deleted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Confirmation: File successfully deleted!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('File not found or already deleted!'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L1 Q5: Delete File')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _createDummyFile,
              child: const Text('1. Create Sample File'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: _handleDelete,
              child: const Text('2. Delete File & Show Confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level1Question5Screen()));
}
