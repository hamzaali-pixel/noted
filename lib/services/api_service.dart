import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:share_plus/share_plus.dart';

class GeneratedNotesScreen extends StatefulWidget {
  final String notes;

  GeneratedNotesScreen({required this.notes});

  @override
  _GeneratedNotesScreenState createState() => _GeneratedNotesScreenState();
}

class _GeneratedNotesScreenState extends State<GeneratedNotesScreen> {
  late quill.QuillController _quillController;

  @override
  void initState() {
    super.initState();

    // Configure the markdown parser
    final mdDocument = md.Document(encodeHtml: false);
    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

    // Convert markdown to Quill Delta
    final delta = mdToDelta.convert(widget.notes);

    // Initialize the QuillController with the Delta
    _quillController = quill.QuillController(
      document: quill.Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Banner Section
            Container(
              color: const Color.fromARGB(255, 39, 36, 42), // Banner background color
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/icon.png', // Your image path
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Not',
                              style: TextStyle(
                                color: Color.fromARGB(255, 229, 196, 255),
                                fontSize: 32,
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Ed.',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 147, 59, 198),
                                fontSize: 35,
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Your Note Taking Assistant',
                        style: TextStyle(
                          color: Color.fromARGB(255, 235, 227, 227),
                          fontSize: 18,
                          fontFamily: 'Horizon',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Editable Quill Editor Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: quill.QuillEditor.basic(
                  controller: _quillController,
                ),
              ),
            ),
            // Quill Toolbar
            quill.QuillToolbar.simple(controller: _quillController),
            const SizedBox(height: 10),
            // Buttons for Copy and Share
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: _quillController.document.toPlainText()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notes copied to clipboard')),
                      );
                    },
                    icon: Icon(Icons.copy),
                    label: Text('Copy'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Share.share(_quillController.document.toPlainText());
                    },
                    icon: Icon(Icons.share),
                    label: Text('Share'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
