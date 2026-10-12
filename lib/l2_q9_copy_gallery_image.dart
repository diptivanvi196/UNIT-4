import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Level 2 — Question 9: Copy an image picked from gallery into app's documents directory
class Level2Question9Screen extends StatefulWidget {
  const Level2Question9Screen({super.key});

  @override
  State<Level2Question9Screen> createState() => _Level2Question9ScreenState();
}

class _Level2Question9ScreenState extends State<Level2Question9Screen> {
  File? _savedImageFile;
  String _status = 'No image selected yet';

  Future<void> _pickAndCopyImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get Documents directory using path_provider
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String newFileName = 'copied_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      String destinationPath = '${appDocDir.path}/$newFileName';

      // Copy image from temporary picked location into app's document directory
      File pickedImageFile = File(pickedFile.path);
      File savedCopy = await pickedImageFile.copy(destinationPath);

      setState(() {
        _savedImageFile = savedCopy;
        _status = 'Copied to app documents:\n${savedCopy.path}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('L2 Q9: Copy Gallery Image')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _pickAndCopyImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pick Image & Copy to Documents'),
            ),
            const SizedBox(height: 20),
            Text(_status, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            if (_savedImageFile != null)
              Expanded(
                child: Image.file(_savedImageFile!),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Level2Question9Screen()));
}
