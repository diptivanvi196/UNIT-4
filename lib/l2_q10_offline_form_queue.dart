import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 2 — Question 10: Simple offline queue saving unsent form data locally using SharedPreferences
class Level2Question10Screen extends StatefulWidget {
  const Level2Question10Screen({super.key});

  @override
  State<Level2Question10Screen> createState() => _Level2Question10ScreenState();
}

class _Level2Question10ScreenState extends State<Level2Question10Screen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isOnline = false;
  List<Map<String, dynamic>> _offlineQueue = [];

  @override
  void initState() {
    super.initState();
    _loadOfflineQueue();
  }

  Future<void> _loadOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    String? queueJson = prefs.getString('offline_form_queue');
    if (queueJson != null) {
      List<dynamic> list = jsonDecode(queueJson);
      setState(() {
        _offlineQueue = list.cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _saveOfflineQueue() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_form_queue', jsonEncode(_offlineQueue));
  }

  Future<void> _submitForm() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) return;

    final formData = {
      'name': _nameController.text,
      'email': _emailController.text,
      'timestamp': DateTime.now().toIso8601String(),
    };

    if (_isOnline) {
      // Send directly online
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted online successfully!')),
        );
      }
    } else {
      // Save locally to offline queue in SharedPreferences
      setState(() {
        _offlineQueue.add(formData);
      });
      await _saveOfflineQueue();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Offline! Form queued in SharedPreferences.')),
        );
      }
    }

    _nameController.clear();
    _emailController.clear();
  }

  Future<void> _flushSyncQueue() async {
    if (_offlineQueue.isEmpty) return;
    int count = _offlineQueue.length;
    setState(() {
      _offlineQueue.clear();
    });
    await _saveOfflineQueue();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Synced $count queued items to server!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q10: Offline Form Queue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Network Mode'),
              subtitle: Text(_isOnline ? 'Online' : 'Offline'),
              value: _isOnline,
              onChanged: (val) => setState(() => _isOnline = val),
            ),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _submitForm, child: const Text('Submit Form')),
            const Divider(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Queued Offline Forms: ${_offlineQueue.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                if (_isOnline && _offlineQueue.isNotEmpty)
                  ElevatedButton(onPressed: _flushSyncQueue, child: const Text('Sync Queue')),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _offlineQueue.length,
                itemBuilder: (context, index) {
                  final item = _offlineQueue[index];
                  return ListTile(
                    title: Text(item['name'] ?? ''),
                    subtitle: Text('${item['email']} (${item['timestamp']})'),
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
  runApp(const MaterialApp(home: Level2Question10Screen()));
}
