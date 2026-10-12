import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Level 3 — Question 3: Offline-first To-Do app using Hive & connectivity_plus sync
class Level3Question3Screen extends StatefulWidget {
  const Level3Question3Screen({super.key});

  @override
  State<Level3Question3Screen> createState() => _Level3Question3ScreenState();
}

class _Level3Question3ScreenState extends State<Level3Question3Screen> {
  Box? _todoBox;
  bool _isOnline = false;
  final TextEditingController _taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initHiveAndConnectivity();
  }

  Future<void> _initHiveAndConnectivity() async {
    await Hive.initFlutter();
    _todoBox = await Hive.openBox('todos');
    setState(() {});

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool online = results.any((r) => r != ConnectivityResult.none);
      setState(() => _isOnline = online);
      if (online) {
        _syncTodosToMockApi();
      }
    });
  }

  Future<void> _syncTodosToMockApi() async {
    if (_todoBox == null) return;
    for (var key in _todoBox!.keys) {
      var item = _todoBox!.get(key);
      if (item is Map && item['synced'] == false) {
        // Simulate REST API POST request
        await Future.delayed(const Duration(milliseconds: 300));
        item['synced'] = true;
        await _todoBox!.put(key, item);
      }
    }
    setState(() {});
  }

  void _addTodo() {
    if (_taskController.text.trim().isEmpty || _todoBox == null) return;
    _todoBox!.add({
      'task': _taskController.text.trim(),
      'synced': _isOnline,
    });
    _taskController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('L3 Q3: Hive Offline To-Do'),
        actions: [
          Icon(_isOnline ? Icons.wifi : Icons.wifi_off, color: _isOnline ? Colors.green : Colors.red),
          const SizedBox(width: 16),
        ],
      ),
      body: _todoBox == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: TextField(controller: _taskController, decoration: const InputDecoration(labelText: 'Task Title'))),
                      IconButton(icon: const Icon(Icons.add), onPressed: _addTodo),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: _todoBox!.listenable(),
                      builder: (context, Box box, _) {
                        return ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            var todo = box.getAt(index);
                            return ListTile(
                              title: Text(todo['task'] ?? ''),
                              trailing: Chip(
                                label: Text(todo['synced'] == true ? 'Synced' : 'Local Only'),
                                backgroundColor: todo['synced'] == true ? Colors.green.shade100 : Colors.orange.shade100,
                              ),
                            );
                          },
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
  runApp(const MaterialApp(home: Level3Question3Screen()));
}
