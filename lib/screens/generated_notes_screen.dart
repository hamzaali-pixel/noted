import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:share_plus/share_plus.dart';
import '../helpers/database_helper.dart';
import '../models/note.dart';

class GeneratedNotesScreen extends StatefulWidget {
  final String notes;

  GeneratedNotesScreen({required this.notes});

  @override
  _GeneratedNotesScreenState createState() => _GeneratedNotesScreenState();
}

class _GeneratedNotesScreenState extends State<GeneratedNotesScreen> {
  late quill.QuillController _quillController;
  bool _showToolbar = false; // To toggle toolbar visibility

  @override
  void initState() {
    super.initState();
    final mdDocument = md.Document(encodeHtml: false);
    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
    final delta = mdToDelta.convert(widget.notes);
    _quillController = quill.QuillController(
      document: quill.Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  Future<void> _askForNoteTitle() async {
    String noteTitle = '';
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Note Title'),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: 'Enter title here'),
            onChanged: (value) {
              noteTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteTitle.isNotEmpty) {
                  _saveNote(noteTitle);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a title')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _saveNote(String title) async {
    Note newNote = Note(
      title: title,
      content: widget.notes,
      createdAt: DateTime.now(),
    );
    await DatabaseHelper.insertNote(newNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note saved successfully')),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 123, 42, 185)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Generated Notes',
          style: TextStyle(
            fontFamily: 'Horizon',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 123, 42, 185),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showToolbar ? Icons.keyboard_arrow_up : Icons.edit, color: Color.fromARGB(255, 123, 42, 185)),
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
                      Clipboard.setData(ClipboardData(text: _quillController.document.toPlainText()));
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
                    onPressed: _askForNoteTitle,
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