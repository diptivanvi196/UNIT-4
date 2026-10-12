import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 2 — Question 2: Student class with toJson() and fromJson() methods & testing
class Student {
  final int id;
  final String name;
  final String course;

  Student({required this.id, required this.name, required this.course});

  // Convert Student object to Map / JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course': course,
    };
  }

  // Create Student object from Map / JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      name: json['name'] as String,
      course: json['course'] as String,
    );
  }

  @override
  String toString() => 'Student(id: $id, name: $name, course: $course)';
}

class Level2Question2Screen extends StatefulWidget {
  const Level2Question2Screen({super.key});

  @override
  State<Level2Question2Screen> createState() => _Level2Question2ScreenState();
}

class _Level2Question2ScreenState extends State<Level2Question2Screen> {
  String _jsonOutput = '';
  String _reconstructedStudentStr = '';

  void _testStudentConversion() {
    // 1. Create Student Object
    Student originalStudent = Student(id: 101, name: 'Dipti Patel', course: 'Computer Engineering');

    // 2. Convert to JSON Map & String
    Map<String, dynamic> studentMap = originalStudent.toJson();
    String jsonString = jsonEncode(studentMap);

    // 3. Convert JSON String back to Student Object
    Map<String, dynamic> decodedMap = jsonDecode(jsonString) as Map<String, dynamic>;
    Student restoredStudent = Student.fromJson(decodedMap);

    setState(() {
      _jsonOutput = jsonString;
      _reconstructedStudentStr = restoredStudent.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q2: Student Model JSON')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _testStudentConversion,
              child: const Text('Test Student toJson() & fromJson()'),
            ),
            const SizedBox(height: 20),
            const Text('Generated JSON String (toJson):', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_jsonOutput, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 20),
            const Text('Reconstructed Student Object (fromJson):', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_reconstructedStudentStr, style: const TextStyle(color: Colors.green, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question2Screen()));
}
