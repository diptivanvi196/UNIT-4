import 'package:flutter/material.dart';

import 'l1_q1_app_doc_dir.dart';
import 'l1_q2_write_file.dart';
import 'l1_q3_read_file_widget.dart';
import 'l1_q4_check_file_exists.dart';
import 'l1_q5_delete_file.dart';
import 'l1_q6_pref_string.dart';
import 'l1_q7_pref_counter.dart';
import 'l1_q8_memory_cache.dart';
import 'l1_q9_map_to_json.dart';
import 'l1_q10_json_to_map.dart';

import 'l2_q1_file_notes.dart';
import 'l2_q2_student_model.dart';
import 'l2_q3_pref_string_list.dart';
import 'l2_q4_cache_first_loader.dart';
import 'l2_q5_clear_cache.dart';
import 'l2_q6_theme_settings.dart';
import 'l2_q7_append_file.dart';
import 'l2_q8_student_list_file.dart';
import 'l2_q9_copy_gallery_image.dart';
import 'l2_q10_offline_form_queue.dart';

import 'l3_q1_json_crud_notes.dart';
import 'l3_q2_image_cache.dart';
import 'l3_q3_hive_offline_todo.dart';
import 'l3_q4_generic_repository.dart';
import 'l3_q5_timed_cache.dart';
import 'l3_q6_nested_json_student.dart';
import 'l3_q7_offline_sync.dart';
import 'l3_q8_file_logger.dart';
import 'l3_q9_api_cache_fallback.dart';
import 'l3_q10_offline_data_pipeline.dart';

void main() {
  runApp(const MasterApp());
}

class MasterApp extends StatelessWidget {
  const MasterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Data & Storage Questions',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), useMaterial3: true),
      home: const MasterHomeScreen(),
    );
  }
}

class QuestionItem {
  final String title;
  final String description;
  final Widget screen;

  QuestionItem({required this.title, required this.description, required this.screen});
}

class MasterHomeScreen extends StatelessWidget {
  const MasterHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<QuestionItem>> sections = {
      'Level 1 — Easy': [
        QuestionItem(title: 'Q1: App Docs Directory Path', description: 'Print path returned by getApplicationDocumentsDirectory()', screen: const Level1Question1Screen()),
        QuestionItem(title: 'Q2: Write File', description: 'Create file and write "Hello Flutter" using writeAsString()', screen: const Level1Question2Screen()),
        QuestionItem(title: 'Q3: Read File to Text Widget', description: 'Read file using readAsString() and display in Text widget', screen: const Level1Question3Screen()),
        QuestionItem(title: 'Q4: Check File Exists', description: 'Check whether file exists using exists() before reading', screen: const Level1Question4Screen()),
        QuestionItem(title: 'Q5: Delete File', description: 'Delete file using file.delete() and show confirmation', screen: const Level1Question5Screen()),
        QuestionItem(title: 'Q6: SharedPreferences String', description: 'Store and retrieve String using SharedPreferences', screen: const Level1Question6Screen()),
        QuestionItem(title: 'Q7: Persisted Counter', description: 'Store integer counter in SharedPreferences and increment', screen: const Level1Question7Screen()),
        QuestionItem(title: 'Q8: In-Memory Cache', description: 'Simple memory cache using Map to reuse API data', screen: const Level1Question8Screen()),
        QuestionItem(title: 'Q9: Map to JSON', description: 'Convert Dart Map to JSON string using jsonEncode()', screen: const Level1Question9Screen()),
        QuestionItem(title: 'Q10: JSON to Map', description: 'Convert JSON string back to Dart Map using jsonDecode()', screen: const Level1Question10Screen()),
      ],
      'Level 2 — Moderate': [
        QuestionItem(title: 'Q1: Simple Notes File App', description: 'Note saved to and loaded from local file', screen: const Level2Question1Screen()),
        QuestionItem(title: 'Q2: Student Model JSON', description: 'Student class with toJson() and fromJson() methods', screen: const Level2Question2Screen()),
        QuestionItem(title: 'Q3: String List Preferences', description: 'Save list of Strings to SharedPreferences & show in ListView', screen: const Level2Question3Screen()),
        QuestionItem(title: 'Q4: Cache-First Loader', description: 'Checks memory cache before fetching from http API', screen: const Level2Question4Screen()),
        QuestionItem(title: 'Q5: Clear Cache Button', description: 'Button that clears cache Map forcing fresh fetch', screen: const Level2Question5Screen()),
        QuestionItem(title: 'Q6: Theme Preference', description: 'Settings screen saving dark/light theme in SharedPreferences', screen: const Level2Question6Screen()),
        QuestionItem(title: 'Q7: Append File Content', description: 'Function that appends text to existing file', screen: const Level2Question7Screen()),
        QuestionItem(title: 'Q8: Student List File JSON', description: 'Stores list of Student objects as JSON in a file', screen: const Level2Question8Screen()),
        QuestionItem(title: 'Q9: Copy Gallery Image', description: 'Copy image picked from gallery into documents directory', screen: const Level2Question9Screen()),
        QuestionItem(title: 'Q10: Offline Form Queue', description: 'Save unsent forms locally in SharedPreferences when offline', screen: const Level2Question10Screen()),
      ],
      'Level 3 — Hard': [
        QuestionItem(title: 'Q1: Complete JSON CRUD Notes', description: 'CRUD Notes app storing all notes as JSON list in file', screen: const Level3Question1Screen()),
        QuestionItem(title: 'Q2: Image Caching Layer', description: 'Disk image cache layer for network downloaded images', screen: const Level3Question2Screen()),
        QuestionItem(title: 'Q3: Hive Offline To-Do', description: 'Offline-first To-Do with Hive & connectivity_plus sync', screen: const Level3Question3Screen()),
        QuestionItem(title: 'Q4: Generic Repository Pattern', description: 'Generic repo abstracting Local & Remote Data Sources', screen: const Level3Question4Screen()),
        QuestionItem(title: 'Q5: Timed Expiry Cache', description: 'Cache system auto-refetching after 5 minutes timeout', screen: const Level3Question5Screen()),
        QuestionItem(title: 'Q6: Nested JSON Student', description: 'Nested model (Student with Marks list) custom JSON', screen: const Level3Question6Screen()),
        QuestionItem(title: 'Q7: Offline Sync Listener', description: 'Auto-push offline records when connectivity_plus goes online', screen: const Level3Question7Screen()),
        QuestionItem(title: 'Q8: File Logging & Export', description: 'File-based logging system with share_plus file export', screen: const Level3Question8Screen()),
        QuestionItem(title: 'Q9: API Cache Fallback', description: 'Download JSON, cache locally, fallback on network failure', screen: const Level3Question9Screen()),
        QuestionItem(title: 'Q10: Complete Offline Pipeline', description: 'Full offline pipeline: API fetch, save, load, edit & re-sync', screen: const Level3Question10Screen()),
      ],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Questions Index (30 Files)'),
        centerTitle: true,
      ),
      body: ListView(
        children: sections.entries.map((entry) {
          return ExpansionTile(
            initiallyExpanded: true,
            title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            children: entry.value.map((q) {
              return ListTile(
                title: Text(q.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(q.description),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => q.screen));
                },
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
