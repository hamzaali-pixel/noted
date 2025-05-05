// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import '../models/note.dart';
// import 'package:markdown/markdown.dart' as md;
// import 'package:markdown_quill/markdown_quill.dart';
// import 'package:share_plus/share_plus.dart';
// import '../helpers/database_helper.dart'; // Import the database helper

// class NoteDetailScreen extends StatefulWidget {
//   final Note note;

//   NoteDetailScreen({required this.note});

//   @override
//   _NoteDetailScreenState createState() => _NoteDetailScreenState();
// }

// class _NoteDetailScreenState extends State<NoteDetailScreen> {
//   late quill.QuillController _quillController;

//   @override
//   void initState() {
//     super.initState();

//     // 1) Create a Markdown Document
//     final mdDocument = md.Document(encodeHtml: false);

//     // 2) Create a MarkdownToDelta converter
//     final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

//     // 3) Convert the note content (Markdown) into a Delta
//     final delta = mdToDelta.convert(widget.note.content);

//     // 4) Build your QuillController from that Delta
//     _quillController = quill.QuillController(
//       document: quill.Document.fromDelta(delta),
//       selection: const TextSelection.collapsed(offset: 0),
//     );
//   }

//   @override
//   void dispose() {
//     _quillController.dispose();
//     super.dispose();
//   }

//   // Function to convert Quill content to Markdown
//   String _convertQuillToMarkdown() {
//     // Convert the Quill document to Delta
//     final delta = _quillController.document.toDelta();

//     // Use DeltaToMarkdown to convert Delta to Markdown
//     final deltaToMarkdown = DeltaToMarkdown();
//     return deltaToMarkdown.convert(delta);
//   }

//   // Function to save the updated note
//   void _saveNote() async {
//     // Get the edited content from Quill editor in Markdown format
//     String updatedContent = _convertQuillToMarkdown();

//     // Update the note object (or create a new one)
//     Note updatedNote = Note(
//       id: widget.note.id, // Keep the same ID
//       title: widget.note.title,
//       content: updatedContent, // Save the content as Markdown
//       createdAt: widget.note.createdAt, // Keep the original creation date
//     );

//     // Save the updated note in the database
//     await DatabaseHelper.insertNote(updatedNote);

//     // Notify the user that the note has been saved
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Note saved successfully')),
//     );

//     // Optionally, you can navigate back after saving
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(  // ⬅️ Add this to avoid overlap with status bar
//         child: Column(
//           children: [
//             quill.QuillToolbar.simple(controller: _quillController),
//             const SizedBox(height: 10),
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.all(16.0),
//                 child: quill.QuillEditor.basic(
//                   controller: _quillController,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       Clipboard.setData(ClipboardData(
//                           text: _quillController.document.toPlainText()));
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Notes copied to clipboard')),
//                       );
//                     },
//                     icon: Icon(Icons.copy),
//                     label: Text('Copy'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       Share.share(_quillController.document.toPlainText());
//                     },
//                     icon: Icon(Icons.share),
//                     label: Text('Share'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: _saveNote,
//                     icon: Icon(Icons.save),
//                     label: Text('Save'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../models/note.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:share_plus/share_plus.dart';
import '../helpers/database_helper.dart'; // Import the database helper

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  NoteDetailScreen({required this.note});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late quill.QuillController _quillController;
  bool _showToolbar = false; // To toggle toolbar visibility

  @override
  void initState() {
    super.initState();

    // 1) Create a Markdown Document
    final mdDocument = md.Document(encodeHtml: false);

    // 2) Create a MarkdownToDelta converter
    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);

    // 3) Convert the note content (Markdown) into a Delta
    final delta = mdToDelta.convert(widget.note.content);

    // 4) Build your QuillController from that Delta
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

  // Function to convert Quill content to Markdown
  String _convertQuillToMarkdown() {
    // Convert the Quill document to Delta
    final delta = _quillController.document.toDelta();

    // Use DeltaToMarkdown to convert Delta to Markdown
    final deltaToMarkdown = DeltaToMarkdown();
    return deltaToMarkdown.convert(delta);
  }

  // Function to save the updated note
  void _saveNote() async {
    // Get the edited content from Quill editor in Markdown format
    String updatedContent = _convertQuillToMarkdown();

    // Update the note object (or create a new one)
    Note updatedNote = Note(
      id: widget.note.id, // Keep the same ID
      title: widget.note.title,
      content: updatedContent, // Save the content as Markdown
      createdAt: widget.note.createdAt, // Keep the original creation date
    );

    // Save the updated note in the database
    await DatabaseHelper.insertNote(updatedNote);

    // Notify the user that the note has been saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note saved successfully')),
    );

    // Navigate back after saving
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 123, 42, 185)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.note.title,
              style: TextStyle(
                fontFamily: 'Horizon',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 123, 42, 185),
              ),
            ),
            Text(
              _formatDate(widget.note.createdAt),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showToolbar ? Icons.keyboard_arrow_up : Icons.edit,
              color: Color.fromARGB(255, 123, 42, 185),
            ),
            onPressed: () {
              setState(() {
                _showToolbar = !_showToolbar;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),
            
            // Collapsible toolbar
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _showToolbar ? 50 : 0,
              child: SingleChildScrollView(
                child: quill.QuillToolbar.simple(controller: _quillController),
              ),
            ),
            
            // Editor area
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 246, 241, 251),
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.all(16),
                child: quill.QuillEditor.basic(
                  controller: _quillController,
                ),
              ),
            ),
            
            // Bottom action bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: _quillController.document.toPlainText()));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notes copied to clipboard')),
                      );
                    },
                    icon: Icons.copy,
                    label: 'Copy',
                  ),
                  _buildActionButton(
                    onPressed: () {
                      Share.share(_quillController.document.toPlainText());
                    },
                    icon: Icons.share,
                    label: 'Share',
                  ),
                  _buildActionButton(
                    onPressed: _saveNote,
                    icon: Icons.save,
                    label: 'Save',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 238, 222, 255),
        foregroundColor: Color.fromARGB(255, 123, 42, 185),
      ),
    );
  }
}