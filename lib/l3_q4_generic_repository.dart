import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 3 — Question 4: Generic Repository abstracting Local and Remote Data Sources
abstract class LocalDataSource<T> {
  Future<List<T>> getLocalItems();
  Future<void> saveLocalItems(List<T> items);
}

abstract class RemoteDataSource<T> {
  Future<List<T>> fetchRemoteItems();
}

class GenericRepository<T> {
  final LocalDataSource<T> local;
  final RemoteDataSource<T> remote;

  GenericRepository({required this.local, required this.remote});

  Future<List<T>> getItems({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      List<T> localData = await local.getLocalItems();
      if (localData.isNotEmpty) {
        print('Repository: Returning from Local Data Source');
        return localData;
      }
    }
    print('Repository: Fetching from Remote Data Source & saving to Local');
    List<T> remoteData = await remote.fetchRemoteItems();
    await local.saveLocalItems(remoteData);
    return remoteData;
  }
}

// Concrete Implementation Example
class StringLocalDataSource implements LocalDataSource<String> {
  @override
  Future<List<String>> getLocalItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('repo_strings') ?? [];
  }

  @override
  Future<void> saveLocalItems(List<String> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('repo_strings', items);
  }
}

class StringRemoteDataSource implements RemoteDataSource<String> {
  @override
  Future<List<String>> fetchRemoteItems() async {
    await Future.delayed(const Duration(seconds: 1)); // Mock API delay
    return ['Item A (Remote)', 'Item B (Remote)', 'Item C (Remote)'];
  }
}

class Level3Question4Screen extends StatefulWidget {
  const Level3Question4Screen({super.key});

  @override
  State<Level3Question4Screen> createState() => _Level3Question4ScreenState();
}

class _Level3Question4ScreenState extends State<Level3Question4Screen> {
  late GenericRepository<String> _repository;
  List<String> _items = [];
  String _sourceStatus = 'No data fetched yet';

  @override
  void initState() {
    super.initState();
    _repository = GenericRepository(
      local: StringLocalDataSource(),
      remote: StringRemoteDataSource(),
    );
  }

  Future<void> _loadData({bool force = false}) async {
    List<String> data = await _repository.getItems(forceRefresh: force);
    setState(() {
      _items = data;
      _sourceStatus = force ? 'Fetched from Remote API' : 'Loaded via Repository';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q4: Generic Repository Pattern')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _loadData(force: false), child: const Text('Load Data')),
                ElevatedButton(onPressed: () => _loadData(force: true), child: const Text('Force Remote Refresh')),
              ],
            ),
            const SizedBox(height: 20),
            Text(_sourceStatus, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) => ListTile(title: Text(_items[index])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question4Screen()));
}
