import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Level 2 — Question 3: Save list of Strings to SharedPreferences & display in ListView
class Level2Question3Screen extends StatefulWidget {
  const Level2Question3Screen({super.key});

  @override
  State<Level2Question3Screen> createState() => _Level2Question3ScreenState();
}

class _Level2Question3ScreenState extends State<Level2Question3Screen> {
  final TextEditingController _itemController = TextEditingController();
  List<String> _itemsList = [];

  @override
  void initState() {
    super.initState();
    _loadListFromPrefs();
  }

  Future<void> _loadListFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _itemsList = prefs.getStringList('saved_string_list') ?? ['Default Item 1', 'Default Item 2'];
    });
  }

  Future<void> _addItemToList() async {
    if (_itemController.text.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _itemsList.add(_itemController.text.trim());
    });
    await prefs.setStringList('saved_string_list', _itemsList);
    _itemController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q3: SharedPreferences String List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(labelText: 'Enter new item'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blue, size: 36),
                  onPressed: _addItemToList,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _itemsList.isEmpty
                  ? const Center(child: Text('No items stored in preferences'))
                  : ListView.builder(
                      itemCount: _itemsList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(_itemsList[index]),
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
  runApp(const MaterialApp(home: Level2Question3Screen()));
}
