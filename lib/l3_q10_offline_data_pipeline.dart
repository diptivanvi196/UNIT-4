import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 10: Complete offline-data pipeline (fetch, serialize, save, deserialize on launch, display, local edit, re-sync)
class ArticleItem {
  final int id;
  String title;
  bool isEditedLocally;

  ArticleItem({required this.id, required this.title, this.isEditedLocally = false});

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'isEditedLocally': isEditedLocally};

  factory ArticleItem.fromJson(Map<String, dynamic> json) => ArticleItem(
        id: json['id'] as int,
        title: json['title'] as String,
        isEditedLocally: json['isEditedLocally'] as bool? ?? false,
      );
}

class Level3Question10Screen extends StatefulWidget {
  const Level3Question10Screen({super.key});

  @override
  State<Level3Question10Screen> createState() => _Level3Question10ScreenState();
}

class _Level3Question10ScreenState extends State<Level3Question10Screen> {
  List<ArticleItem> _articles = [];
  String _pipelineStatus = 'Pipeline Initializing...';

  @override
  void initState() {
    super.initState();
    _runInitialPipelineLaunch();
  }

  Future<File> _getPipelineFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/pipeline_articles.json');
  }

  // Pipeline Step: Deserialize on launch or fetch initial mock API data
  Future<void> _runInitialPipelineLaunch() async {
    final file = await _getPipelineFile();
    if (await file.exists()) {
      // Deserialize on launch
      String rawJson = await file.readAsString();
      List<dynamic> list = jsonDecode(rawJson);
      setState(() {
        _articles = list.map((e) => ArticleItem.fromJson(e as Map<String, dynamic>)).toList();
        _pipelineStatus = 'Deserialized articles from local file on launch.';
      });
    } else {
      // Fetch initial mock API data & serialize to file
      _fetchAndSeedFromApi();
    }
  }

  Future<void> _fetchAndSeedFromApi() async {
    // Simulate remote API response
    await Future.delayed(const Duration(seconds: 1));
    List<ArticleItem> initialData = [
      ArticleItem(id: 1, title: 'Flutter Offline Data Architecture'),
      ArticleItem(id: 2, title: 'State Management & Storage'),
    ];
    _articles = initialData;
    await _saveArticlesToFile();
    setState(() {
      _pipelineStatus = 'Fetched initial API data, serialized & saved to local file!';
    });
  }

  Future<void> _saveArticlesToFile() async {
    final file = await _getPipelineFile();
    String raw = jsonEncode(_articles.map((a) => a.toJson()).toList());
    await file.writeAsString(raw);
  }

  void _editArticle(ArticleItem article) {
    final ctrl = TextEditingController(text: article.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Article #${article.id}'),
        content: TextField(controller: ctrl),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                article.title = ctrl.text;
                article.isEditedLocally = true;
              });
              _saveArticlesToFile(); // Save edit locally
              Navigator.pop(ctx);
            },
            child: const Text('Save Local Edit'),
          ),
        ],
      ),
    );
  }

  Future<void> _reSyncToServer() async {
    List<ArticleItem> editedItems = _articles.where((a) => a.isEditedLocally).toList();
    if (editedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No local edits to sync!')));
      return;
    }

    // Push local edits back to mock server
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      for (var a in editedItems) {
        a.isEditedLocally = false;
      }
      _pipelineStatus = 'Re-synced ${editedItems.length} local edits back to server!';
    });
    await _saveArticlesToFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q10: Complete Offline Pipeline')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(_pipelineStatus, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _reSyncToServer,
              icon: const Icon(Icons.sync),
              label: const Text('Re-sync Local Edits to Server'),
            ),
            const Divider(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final item = _articles[index];
                  return Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.isEditedLocally ? 'Local Edit (Pending Sync)' : 'Synced'),
                      trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _editArticle(item)),
                    ),
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
  runApp(const MaterialApp(home: Level3Question10Screen()));
}
