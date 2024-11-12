// lib/upload_screen.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'playback_screen.dart';

class UploadScreen extends StatelessWidget {
  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      // Use Navigator.pushReplacement to replace the Upload Screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PlaybackScreen(filePath: filePath),
        ),
      );
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('Upload Audio'), leading: BackButton()),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _pickFile(context),
          icon: Icon(Icons.folder_open),
          label: Text('Select Audio File'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
    );
  }
}
