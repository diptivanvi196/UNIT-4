import 'dart:convert';
import 'package:flutter/material.dart';

/// Level 3 — Question 6: Nested JSON data model (Student containing list of Marks)
class Mark {
  final String subject;
  final int score;

  Mark({required this.subject, required this.score});

  Map<String, dynamic> toJson() => {'subject': subject, 'score': score};

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
      subject: json['subject'] as String,
      score: json['score'] as int,
    );
  }
}

class NestedStudent {
  final int rollNo;
  final String name;
  final List<Mark> marksList;

  NestedStudent({required this.rollNo, required this.name, required this.marksList});

  Map<String, dynamic> toJson() => {
        'rollNo': rollNo,
        'name': name,
        'marksList': marksList.map((m) => m.toJson()).toList(),
      };

  factory NestedStudent.fromJson(Map<String, dynamic> json) {
    var rawList = json['marksList'] as List<dynamic>;
    List<Mark> parsedMarks = rawList.map((e) => Mark.fromJson(e as Map<String, dynamic>)).toList();
    return NestedStudent(
      rollNo: json['rollNo'] as int,
      name: json['name'] as String,
      marksList: parsedMarks,
    );
  }
}

class Level3Question6Screen extends StatefulWidget {
  const Level3Question6Screen({super.key});

  @override
  State<Level3Question6Screen> createState() => _Level3Question6ScreenState();
}

class _Level3Question6ScreenState extends State<Level3Question6Screen> {
  String _encodedJson = '';
  NestedStudent? _reconstructedStudent;

  void _runNestedSerialization() {
    NestedStudent student = NestedStudent(
      rollNo: 105,
      name: 'Patel Dipti',
      marksList: [
        Mark(subject: 'MAD (Mobile App Dev)', score: 95),
        Mark(subject: 'DBMS', score: 88),
        Mark(subject: 'Software Engg', score: 92),
      ],
    );

    // Encode
    String jsonStr = jsonEncode(student.toJson());

    // Decode back
    Map<String, dynamic> map = jsonDecode(jsonStr);
    NestedStudent restored = NestedStudent.fromJson(map);

    setState(() {
      _encodedJson = jsonStr;
      _reconstructedStudent = restored;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q6: Nested JSON Student & Marks')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _runNestedSerialization, child: const Text('Run Nested Serialization Test')),
            const SizedBox(height: 20),
            const Text('Encoded JSON:', style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(_encodedJson, style: const TextStyle(color: Colors.blue)),
            const SizedBox(height: 20),
            if (_reconstructedStudent != null) ...[
              Text('Decoded Student: ${_reconstructedStudent!.name} (Roll #${_reconstructedStudent!.rollNo})',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              ..._reconstructedStudent!.marksList.map((m) => ListTile(
                    title: Text(m.subject),
                    trailing: Text('${m.score} Marks', style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question6Screen()));
}
