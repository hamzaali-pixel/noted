import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF preview
import 'package:http/http.dart' as http;

class UploadFileScreen extends StatefulWidget {
  const UploadFileScreen({super.key});

  @override
  State<UploadFileScreen> createState() => _UploadFileScreenState();
}

class _UploadFileScreenState extends State<UploadFileScreen> {
  File? _file;
  String _mode = 'summary';  // 'summary' | 'full'
  bool _busy = false;
  String? _fileTypeMessage; // Message for unsupported file types

  // ───────────────────────── pick a file ─────────────────────────
  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'pptx', 'docx'],
    );
    if (res != null && mounted) {
      setState(() {
        _file = File(res.files.single.path!);
        _fileTypeMessage = null; // Reset message when file is selected
      });
      String fileExtension = res.files.single.extension!.toLowerCase();
      if (fileExtension == 'pdf') {
        _fileTypeMessage = null; // No message for PDF
      } else {
        _fileTypeMessage = "Preview not available for $fileExtension files.";
      }
    }
  }

  // ───────────────────────── upload & process ───────────────────
  Future<void> _processFile() async {
    if (_file == null) return;
    setState(() => _busy = true);

    final req = http.MultipartRequest(
      'POST',
      Uri.parse('https://bc2d-185-154-158-212.ngrok-free.app/process_file'),
    )
      ..fields['mode'] = _mode
      ..files.add(await http.MultipartFile.fromPath('file', _file!.path));

    final resp = await req.send();
    setState(() => _busy = false);

    if (resp.statusCode == 200) {
      final body = await resp.stream.bytesToString();
      final notes = jsonDecode(body)['notes'] as String;
      Navigator.pushNamed(context, '/generatedNotes', arguments: notes);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed • code ${resp.statusCode}')),
      );
    }
  }

  // ───────────────────────── UI ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload File')),
      body: Column(
        children: [
          // ▒▒▒ File preview ▒▒▒
          if (_file != null)
            _file!.path.split('.').last.toLowerCase() == 'pdf'
                ? Expanded(
                    child: PDFView(
                      filePath: _file!.path,
                      enableSwipe: true,
                      swipeHorizontal: true,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _fileTypeMessage ?? '',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
          else
            const Expanded(
              child: Center(
                child: Text(
                  'No file selected',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),

          if (_busy) const LinearProgressIndicator(),

          // ▒▒▒ controls ▒▒▒
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Mode selection: Summarize / Full Text
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text('Summarize'),
                        value: 'summary',
                        groupValue: _mode,
                        onChanged: (val) => setState(() => _mode = val!),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text('Full Text'),
                        value: 'full',
                        groupValue: _mode,
                        onChanged: (val) => setState(() => _mode = val!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Buttons for picking a file and uploading
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickFile,
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Choose File'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _file == null || _busy ? null : _processFile,
                      icon: const Icon(Icons.upload),
                      label: const Text('Generate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
