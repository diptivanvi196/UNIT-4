import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 3 — Question 7: Background sync mechanism pushing offline records when connectivity_plus turns online
class Level3Question7Screen extends StatefulWidget {
  const Level3Question7Screen({super.key});

  @override
  State<Level3Question7Screen> createState() => _Level3Question7ScreenState();
}

class _Level3Question7ScreenState extends State<Level3Question7Screen> {
  final TextEditingController _recordController = TextEditingController();
  List<String> _pendingOfflineRecords = [];
  bool _isOnline = false;
  String _syncLog = '';

  @override
  void initState() {
    super.initState();
    _loadPendingRecords();
    _initConnectivityListener();
  }

  Future<void> _loadPendingRecords() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _pendingOfflineRecords = prefs.getStringList('offline_push_records') ?? [];
    });
  }

  void _initConnectivityListener() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool online = results.any((r) => r != ConnectivityResult.none);
      setState(() {
        _isOnline = online;
      });
      if (online) {
        _triggerBackgroundSync();
      }
    });
  }

  Future<void> _addRecord() async {
    if (_recordController.text.trim().isEmpty) return;
    String text = _recordController.text.trim();
    if (_isOnline) {
      setState(() {
        _syncLog = 'Pushed directly to Server: "$text"\n$_syncLog';
      });
    } else {
      final prefs = await SharedPreferences.getInstance();
      _pendingOfflineRecords.add(text);
      await prefs.setStringList('offline_push_records', _pendingOfflineRecords);
      setState(() {
        _syncLog = 'Saved offline: "$text"\n$_syncLog';
      });
    }
    _recordController.clear();
  }

  Future<void> _triggerBackgroundSync() async {
    if (_pendingOfflineRecords.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    int count = _pendingOfflineRecords.length;
    List<String> syncedItems = List.from(_pendingOfflineRecords);

    // Simulate sending batch to remote server
    await Future.delayed(const Duration(seconds: 1));

    _pendingOfflineRecords.clear();
    await prefs.setStringList('offline_push_records', []);

    setState(() {
      _syncLog = 'AUTOMATIC BACKGROUND SYNC: Pushed $count offline items ($syncedItems) to server!\n$_syncLog';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3 Q7: Offline Sync Listener'),
        actions: [
          Chip(
            label: Text(_isOnline ? 'Online' : 'Offline'),
            backgroundColor: _isOnline ? Colors.green.shade100 : Colors.red.shade100,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: TextField(controller: _recordController, decoration: const InputDecoration(labelText: 'Enter record'))),
                ElevatedButton(onPressed: _addRecord, child: const Text('Add Record')),
              ],
            ),
            const SizedBox(height: 20),
            Text('Pending Offline Items: ${_pendingOfflineRecords.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Sync Event Log:', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.grey.shade200,
                child: SingleChildScrollView(child: Text(_syncLog)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question7Screen()));
}
