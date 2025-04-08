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

    // Optionally, you can navigate back after saving
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Use Expanded so the editor takes only the remaining space and is scrollable:
          quill.QuillToolbar.simple(controller: _quillController),
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
          // Buttons for Copy and Share
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16.0),
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
                // Save Button to save the note
                ElevatedButton.icon(
                  onPressed: _saveNote, // Save the note when pressed
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
