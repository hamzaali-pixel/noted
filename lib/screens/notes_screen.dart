import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

class NotesScreen extends StatefulWidget {
  final String notes;

  NotesScreen({required this.notes});

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isEditing = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.notes);
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notes copied to clipboard')),
    );
  }

  void _shareNotes() {
    Share.share(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Notes'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: _copyToClipboard,
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareNotes,
          ),
        ],
      ),
      body: _isEditing
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Edit your notes here...',
                  border: OutlineInputBorder(),
                ),
              ),
            )
          : Markdown(
              data: _controller.text,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(fontSize: 18),
                h1: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                h2: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                h3: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
