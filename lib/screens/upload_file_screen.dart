// import 'dart:convert';
// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart'; // For PDF preview
// import 'package:http/http.dart' as http;

// class UploadFileScreen extends StatefulWidget {
//   const UploadFileScreen({super.key});

//   @override
//   State<UploadFileScreen> createState() => _UploadFileScreenState();
// }

// class _UploadFileScreenState extends State<UploadFileScreen> {
//   File? _file;
//   String _mode = 'summary';  // 'summary' | 'full'
//   bool _busy = false;
//   String? _fileTypeMessage; // Message for unsupported file types

//   // ───────────────────────── pick a file ─────────────────────────
//   Future<void> _pickFile() async {
//     final res = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['pdf', 'pptx', 'docx'],
//     );
//     if (res != null && mounted) {
//       setState(() {
//         _file = File(res.files.single.path!);
//         _fileTypeMessage = null; // Reset message when file is selected
//       });
//       String fileExtension = res.files.single.extension!.toLowerCase();
//       if (fileExtension == 'pdf') {
//         _fileTypeMessage = null; // No message for PDF
//       } else {
//         _fileTypeMessage = "Preview not available for $fileExtension files.";
//       }
//     }
//   }

//   // ───────────────────────── upload & process ───────────────────
//   Future<void> _processFile() async {
//     if (_file == null) return;
//     setState(() => _busy = true);

//     final req = http.MultipartRequest(
//       'POST',
//       Uri.parse('https://bc2d-185-154-158-212.ngrok-free.app/process_file'),
//     )
//       ..fields['mode'] = _mode
//       ..files.add(await http.MultipartFile.fromPath('file', _file!.path));

//     final resp = await req.send();
//     setState(() => _busy = false);

//     if (resp.statusCode == 200) {
//       final body = await resp.stream.bytesToString();
//       final notes = jsonDecode(body)['notes'] as String;
//       Navigator.pushNamed(context, '/generatedNotes', arguments: notes);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Upload failed • code ${resp.statusCode}')),
//       );
//     }
//   }

//   // ───────────────────────── UI ─────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Upload File')),
//       body: Column(
//         children: [
//           // ▒▒▒ File preview ▒▒▒
//           if (_file != null)
//             _file!.path.split('.').last.toLowerCase() == 'pdf'
//                 ? Expanded(
//                     child: PDFView(
//                       filePath: _file!.path,
//                       enableSwipe: true,
//                       swipeHorizontal: true,
//                     ),
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(
//                       _fileTypeMessage ?? '',
//                       style: const TextStyle(fontSize: 16, color: Colors.grey),
//                     ),
//                   )
//           else
//             const Expanded(
//               child: Center(
//                 child: Text(
//                   'No file selected',
//                   style: TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//               ),
//             ),

//           if (_busy) const LinearProgressIndicator(),

//           // ▒▒▒ controls ▒▒▒
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Mode selection: Summarize / Full Text
//                 Row(
//                   children: [
//                     Expanded(
//                       child: RadioListTile(
//                         title: const Text('Summarize'),
//                         value: 'summary',
//                         groupValue: _mode,
//                         onChanged: (val) => setState(() => _mode = val!),
//                       ),
//                     ),
//                     Expanded(
//                       child: RadioListTile(
//                         title: const Text('Full Text'),
//                         value: 'full',
//                         groupValue: _mode,
//                         onChanged: (val) => setState(() => _mode = val!),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 // Buttons for picking a file and uploading
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: _pickFile,
//                       icon: const Icon(Icons.folder_open),
//                       label: const Text('Choose File'),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: _file == null || _busy ? null : _processFile,
//                       icon: const Icon(Icons.upload),
//                       label: const Text('Generate'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



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
  String? _fileName; // Store the file name for display

  // Main colors matching the app theme
  final Color mainColor = const Color.fromARGB(255, 123, 42, 185);
  final Color lightPurple = const Color.fromARGB(255, 238, 222, 255);

  // ───────────────────────── pick a file ─────────────────────────
  Future<void> _pickFile() async {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'pptx', 'docx'],
    );
    if (res != null && mounted) {
      setState(() {
        _file = File(res.files.single.path!);
        _fileName = res.files.single.name; // Store the file name
        String fileExtension = res.files.single.extension!.toLowerCase();
        
        if (fileExtension == 'pdf') {
          _fileTypeMessage = null; // No message for PDF
        } else if (fileExtension == 'pptx') {
          _fileTypeMessage = "PowerPoint preview not available.";
        } else if (fileExtension == 'docx') {
          _fileTypeMessage = "Word document preview not available.";
        }
      });
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

    try {
      final resp = await req.send();
      
      if (resp.statusCode == 200) {
        final body = await resp.stream.bytesToString();
        final notes = jsonDecode(body)['notes'] as String;
        if (mounted) {
          Navigator.pushNamed(context, '/generatedNotes', arguments: notes);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed • code ${resp.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  // ───────────────────────── UI ─────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Upload Document',
          style: TextStyle(
            fontFamily: 'Horizon',
            color: Color.fromARGB(255, 123, 42, 185),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: mainColor),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // File preview or instructions
            Expanded(
              child: _file != null
                  ? _buildFilePreview()
                  : _buildEmptyState(),
            ),

            // Progress indicator
            if (_busy) 
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(
                      backgroundColor: lightPurple,
                      valueColor: AlwaysStoppedAnimation<Color>(mainColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Processing your document...',
                      style: TextStyle(
                        color: mainColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

            // ▒▒▒ controls ▒▒▒
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Mode selection: Summarize / Full Text
                  Container(
                    decoration: BoxDecoration(
                      color: lightPurple,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            title: const Text(
                              'Summarize',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            value: 'summary',
                            groupValue: _mode,
                            onChanged: (val) => setState(() => _mode = val!),
                            activeColor: mainColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            title: const Text(
                              'Full Text',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            value: 'full',
                            groupValue: _mode,
                            onChanged: (val) => setState(() => _mode = val!),
                            activeColor: mainColor,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildButton(
                          onPressed: _pickFile,
                          icon: Icons.folder_open,
                          label: 'Choose File',
                          isPrimary: false,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildButton(
                          onPressed: _file == null || _busy ? null : _processFile,
                          icon: Icons.upload,
                          label: 'Generate Notes',
                          isPrimary: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required bool isPrimary,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: isPrimary ? Colors.white : mainColor),
      label: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : mainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? mainColor : lightPurple,
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: isPrimary ? 3 : 1,
      ),
    );
  }

  Widget _buildFilePreview() {
    if (_file == null) return const SizedBox.shrink();

    final fileExtension = _file!.path.split('.').last.toLowerCase();
    
    if (fileExtension == 'pdf') {
      // PDF Preview
      return PDFView(
        filePath: _file!.path,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: true,
        pageFling: true,
        pageSnap: true,
        defaultPage: 0,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
      );
    } else {
      // Non-PDF File Selected (docx, pptx)
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                fileExtension == 'docx' ? Icons.description : Icons.slideshow,
                size: 80,
                color: mainColor,
              ),
              const SizedBox(height: 24),
              Text(
                _fileName ?? "Document Selected",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                _fileTypeMessage ?? "File ready for processing",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lightPurple.withOpacity(0.5),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: mainColor.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.upload_file,
              size: 80,
              color: mainColor.withOpacity(0.7),
            ),
            const SizedBox(height: 24),
            const Text(
              "No file selected",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Choose a PDF, Word document, or PowerPoint file to generate notes",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildButton(
              onPressed: _pickFile,
              icon: Icons.add_circle_outline,
              label: 'Select Document',
              isPrimary: true,
            ),
          ],
        ),
      ),
    );
  }
}