import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 1: Complete Notes app with CRUD, storing all notes as JSON list in a file
class Note {
  final String id;
  String title;
  String content;
  DateTime updatedAt;

  Note({required this.id, required this.title, required this.content, required this.updatedAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String,
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

class Level3Question1Screen extends StatefulWidget {
  const Level3Question1Screen({super.key});

  @override
  State<Level3Question1Screen> createState() => _Level3Question1ScreenState();
}

class _Level3Question1ScreenState extends State<Level3Question1Screen> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotesFromFile();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/all_notes_crud.json');
  }

  Future<void> _loadNotesFromFile() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        String jsonStr = await file.readAsString();
        List<dynamic> rawList = jsonDecode(jsonStr);
        setState(() {
          _notes = rawList.map((e) => Note.fromJson(e as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      print('Error loading notes: $e');
    }
  }

  Future<void> _saveNotesToFile() async {
    final file = await _getFile();
    List<Map<String, dynamic>> rawList = _notes.map((n) => n.toJson()).toList();
    await file.writeAsString(jsonEncode(rawList));
  }

  void _showNoteDialog({Note? noteToEdit}) {
    final titleCtrl = TextEditingController(text: noteToEdit?.title ?? '');
    final contentCtrl = TextEditingController(text: noteToEdit?.content ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(noteToEdit == null ? 'Create Note' : 'Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentCtrl, decoration: const InputDecoration(labelText: 'Content')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (titleCtrl.text.isEmpty) return;
              if (noteToEdit == null) {
                // CREATE
                _notes.add(Note(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleCtrl.text,
                  content: contentCtrl.text,
                  updatedAt: DateTime.now(),
                ));
              } else {
                // UPDATE
                noteToEdit.title = titleCtrl.text;
                noteToEdit.content = contentCtrl.text;
                noteToEdit.updatedAt = DateTime.now();
              }
              setState(() {});
              _saveNotesToFile();
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((n) => n.id == id);
    });
    _saveNotesToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q1: JSON CRUD Notes App')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
      body: _notes.isEmpty
          ? const Center(child: Text('No notes created yet'))
          : ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showNoteDialog(noteToEdit: note)),
                        IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteNote(note.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question1Screen()));
}
