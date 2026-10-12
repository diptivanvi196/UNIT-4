import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 8: App storing list of Student objects as JSON in a file & reading back
class StudentModel {
  final int id;
  final String name;
  final double gpa;

  StudentModel({required this.id, required this.name, required this.gpa});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'gpa': gpa};

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      gpa: (json['gpa'] as num).toDouble(),
    );
  }
}

class Level2Question8Screen extends StatefulWidget {
  const Level2Question8Screen({super.key});

  @override
  State<Level2Question8Screen> createState() => _Level2Question8ScreenState();
}

class _Level2Question8ScreenState extends State<Level2Question8Screen> {
  final _nameController = TextEditingController();
  final _gpaController = TextEditingController();
  List<StudentModel> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudentsFromFile();
  }

  Future<File> _getStudentsFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/students_list.json');
  }

  Future<void> _loadStudentsFromFile() async {
    try {
      final file = await _getStudentsFile();
      if (await file.exists()) {
        String jsonStr = await file.readAsString();
        List<dynamic> jsonList = jsonDecode(jsonStr);
        setState(() {
          _students = jsonList.map((e) => StudentModel.fromJson(e as Map<String, dynamic>)).toList();
        });
      }
    } catch (e) {
      print('Error loading students: $e');
    }
  }

  Future<void> _saveStudentsToFile() async {
    try {
      final file = await _getStudentsFile();
      List<Map<String, dynamic>> jsonList = _students.map((s) => s.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Students saved as JSON to local file!')),
        );
      }
    } catch (e) {
      print('Error saving students: $e');
    }
  }

  void _addStudent() {
    if (_nameController.text.isEmpty || _gpaController.text.isEmpty) return;
    final newStudent = StudentModel(
      id: DateTime.now().millisecondsSinceEpoch % 10000,
      name: _nameController.text,
      gpa: double.tryParse(_gpaController.text) ?? 0.0,
    );
    setState(() {
      _students.add(newStudent);
    });
    _nameController.clear();
    _gpaController.clear();
    _saveStudentsToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q8: Student List File JSON')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Student Name')),
            TextField(controller: _gpaController, decoration: const InputDecoration(labelText: 'GPA'), keyboardType: TextInputType.number),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addStudent, child: const Text('Add & Save Student')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _students.length,
                itemBuilder: (context, index) {
                  final st = _students[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${st.id}')),
                    title: Text(st.name),
                    subtitle: Text('GPA: ${st.gpa}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question8Screen()));
}
