import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Level 3 — Question 2: Custom image caching layer for network images
class DiskImageCache {
  static Future<File> getCachedImageFile(String imageUrl) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = imageUrl.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final file = File('${dir.path}/$filename.png');

    if (await file.exists()) {
      print('IMAGE CACHE HIT: ${file.path}');
      return file;
    }

    print('IMAGE CACHE MISS. Downloading from $imageUrl...');
    final response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      return file;
    } else {
      throw Exception('Failed to download network image');
    }
  }
}

class Level3Question2Screen extends StatefulWidget {
  const Level3Question2Screen({super.key});

  @override
  State<Level3Question2Screen> createState() => _Level3Question2ScreenState();
}

class _Level3Question2ScreenState extends State<Level3Question2Screen> {
  final String _sampleImageUrl = 'https://picsum.photos/300/200';
  File? _imageFile;
  bool _loading = false;
  String _status = 'Press button to download & cache image';

  Future<void> _loadImage() async {
    setState(() => _loading = true);
    try {
      File file = await DiskImageCache.getCachedImageFile(_sampleImageUrl);
      setState(() {
        _imageFile = file;
        _status = 'Image loaded successfully from:\n${file.path}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _status = 'Error caching image: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L3 Q2: Image Caching Layer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(onPressed: _loadImage, child: const Text('Load / Cache Image')),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            if (_imageFile != null) Image.file(_imageFile!, height: 200),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level3Question2Screen()));
}
