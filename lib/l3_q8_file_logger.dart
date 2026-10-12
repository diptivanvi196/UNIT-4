import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Level 3 — Question 8: File-based logging system appending timestamped logs & exporting/sharing log file
class FileLogger {
  static Future<File> _getLogFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/app_system_logs.txt');
  }

  static Future<void> log(String message, {String level = 'INFO'}) async {
    final file = await _getLogFile();
    String timestamp = DateTime.now().toIso8601String();
    String logEntry = '[$timestamp] [$level]: $message\n';
    await file.writeAsString(logEntry, mode: FileMode.append);
  }

  static Future<String> readLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      return await file.readAsString();
    }
    return 'No logs recorded yet.';
  }

  static Future<void> clearLogs() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<void> shareLogFile() async {
    final file = await _getLogFile();
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: 'Exported App Logs File');
    }
  }
}

class Level3Question8Screen extends StatefulWidget {
  const Level3Question8Screen({super.key});

  @override
  State<Level3Question8Screen> createState() => _Level3Question8ScreenState();
}

class _Level3Question8ScreenState extends State<Level3Question8Screen> {
  final TextEditingController _msgController = TextEditingController();
  String _logsText = '';

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  Future<void> _refreshLogs() async {
    String content = await FileLogger.readLogs();
    setState(() {
      _logsText = content;
    });
  }

  Future<void> _writeLog() async {
    if (_msgController.text.isEmpty) return;
    await FileLogger.log(_msgController.text);
    _msgController.clear();
    await _refreshLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q8: File Logging & Export')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _msgController, decoration: const InputDecoration(labelText: 'Enter log message')),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton(onPressed: _writeLog, child: const Text('Write Log')),
                ElevatedButton(onPressed: () => FileLogger.shareLogFile(), child: const Text('Export/Share Log')),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                  onPressed: () async {
                    await FileLogger.clearLogs();
                    await _refreshLogs();
                  },
                  child: const Text('Clear Logs'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                color: Colors.black,
                child: SingleChildScrollView(
                  child: Text(
                    _logsText,
                    style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace'),
                  ),
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
  runApp(const MaterialApp(home: Level3Question8Screen()));
}
