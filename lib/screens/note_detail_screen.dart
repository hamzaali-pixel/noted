// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import '../models/note.dart';
// import 'package:markdown/markdown.dart' as md;
// import 'package:markdown_quill/markdown_quill.dart';
// import 'package:share_plus/share_plus.dart';
// import '../helpers/database_helper.dart';
// import '../widgets/chat_widget.dart';

// class NoteDetailScreen extends StatefulWidget {
//   final Note note;

//   NoteDetailScreen({required this.note});

//   @override
//   _NoteDetailScreenState createState() => _NoteDetailScreenState();
// }

// class _NoteDetailScreenState extends State<NoteDetailScreen>
//     with SingleTickerProviderStateMixin {
//   // Define color constants to avoid duplication
//   final Color primaryColor = Color.fromARGB(255, 123, 42, 185);
//   final Color secondaryColor = Color.fromARGB(255, 238, 222, 255);
//   final Color editorBackgroundColor = Color.fromARGB(255, 246, 241, 251);

//   late quill.QuillController _quillController;
//   bool _showToolbar = false;
//   bool _showChatbot = false;
//   bool _showActionMenu = false;

//   late AnimationController _animationController;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();

//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 300),
//     );

//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeInOut,
//     );

//     // Initialize Quill controller with markdown content
//     final mdDocument = md.Document(encodeHtml: false);
//     final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
//     final delta = mdToDelta.convert(widget.note.content);
//     _quillController = quill.QuillController(
//       document: quill.Document.fromDelta(delta),
//       selection: const TextSelection.collapsed(offset: 0),
//     );
//   }

//   @override
//   void dispose() {
//     _quillController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   // Function to convert Quill content to Markdown
//   String _convertQuillToMarkdown() {
//     final delta = _quillController.document.toDelta();
//     final deltaToMarkdown = DeltaToMarkdown();
//     return deltaToMarkdown.convert(delta);
//   }

//   // Function to save the updated note
//   void _saveNote() async {
//     String updatedContent = _convertQuillToMarkdown();
//     Note updatedNote = Note(
//       id: widget.note.id,
//       title: widget.note.title,
//       content: updatedContent,
//       createdAt: widget.note.createdAt,
//     );

//     await DatabaseHelper.insertNote(updatedNote);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Note saved successfully')),
//     );
//     Navigator.pop(context);
//   }

//   String _formatDate(DateTime date) {
//     return "${date.day}/${date.month}/${date.year}";
//   }

//   // Optimized toggle chatbot method
//   void _toggleChatbot() {
//     setState(() {
//       _showChatbot = !_showChatbot;
//       if (_showChatbot) {
//         _animationController.forward();
//       } else {
//         _animationController.reverse();
//       }
//     });
//   }

//   void _toggleActionMenu() {
//     setState(() {
//       _showActionMenu = !_showActionMenu;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             backgroundColor: Colors.white,
//             elevation: 0,
//             leading: IconButton(
//               icon: Icon(Icons.arrow_back, color: primaryColor),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.note.title,
//                   style: TextStyle(
//                     fontFamily: 'Horizon',
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: primaryColor,
//                   ),
//                 ),
//                 Text(
//                   _formatDate(widget.note.createdAt),
//                   style: TextStyle(
//                     color: Colors.black54,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(
//                   _showToolbar ? Icons.keyboard_arrow_up : Icons.edit,
//                   color: primaryColor,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _showToolbar = !_showToolbar;
//                   });
//                 },
//               ),
//             ],
//           ),
//           body: Stack(
//             children: [
//               SafeArea(
//                 child: Column(
//                   children: [
//                     // Divider
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Divider(),
//                     ),

//                     // Collapsible toolbar
//                     AnimatedContainer(
//                       duration: Duration(milliseconds: 300),
//                       height: _showToolbar ? 50 : 0,
//                       child: SingleChildScrollView(
//                         child: quill.QuillToolbar.simple(
//                             controller: _quillController),
//                       ),
//                     ),

//                     // Editor area
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(16.0),
//                         decoration: BoxDecoration(
//                           color: editorBackgroundColor,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         margin: EdgeInsets.all(16),
//                         child: quill.QuillEditor.basic(
//                           controller: _quillController,
//                         ),
//                       ),
//                     ),

//                     // Bottom spacing for floating buttons
//                     SizedBox(height: 60),
//                   ],
//                 ),
//               ),

//               // Floating action buttons
//               Positioned(
//                 bottom: 20,
//                 right: 20,
//                 child: FloatingActionButton(
//                   heroTag: "chatbotButton",
//                   onPressed: _toggleChatbot,
//                   backgroundColor: primaryColor,
//                   child: Icon(
//                     _showChatbot ? Icons.close : Icons.chat,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),

//               // Collapsible action menu (left side)
//               Positioned(
//                 bottom: 20,
//                 left: 20,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Action menu items (visible when expanded)
//                     if (_showActionMenu) ...[
//                       _buildFloatingActionButton(
//                         icon: Icons.copy,
//                         label: 'Copy',
//                         onPressed: () {
//                           Clipboard.setData(ClipboardData(
//                               text: _quillController.document.toPlainText()));
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                                 content: Text('Notes copied to clipboard')),
//                           );
//                         },
//                       ),
//                       SizedBox(height: 10),
//                       _buildFloatingActionButton(
//                         icon: Icons.share,
//                         label: 'Share',
//                         onPressed: () {
//                           Share.share(_quillController.document.toPlainText());
//                         },
//                       ),
//                       SizedBox(height: 10),
//                       _buildFloatingActionButton(
//                         icon: Icons.save,
//                         label: 'Save',
//                         onPressed: _saveNote,
//                       ),
//                       SizedBox(height: 10),
//                     ],
//                     // Toggle button
//                     FloatingActionButton(
//                       heroTag: "actionMenuButton",
//                       onPressed: _toggleActionMenu,
//                       backgroundColor: primaryColor,
//                       mini: true,
//                       child: Icon(
//                         _showActionMenu ? Icons.close : Icons.menu,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),

//         // Chatbot expanded view - optimized overlay
//         AnimatedBuilder(
//           animation: _animation,
//           builder: (context, child) {
//             return _showChatbot
//                 ? Positioned.fill(
//                     child: Material(
//                       color: Colors.transparent,
//                       child: Opacity(
//                         opacity: _animation.value,
//                         child: Container(
//                           color: Colors.white,
//                           child: Column(
//                             children: [
//                               // Status bar height padding
//                               SizedBox(
//                                   height: MediaQuery.of(context).padding.top),
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text(
//                                       'Chat Assistant',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                         color: primaryColor,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       icon: Icon(Icons.close),
//                                       onPressed: _toggleChatbot,
//                                       color: primaryColor,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Divider(),
//                               Expanded(
//                                 // Use the ChatWidget here
//                                 child: ChatWidget(
//                                   notesContent:
//                                       _quillController.document.toPlainText(),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 : Container();
//           },
//         ),
//       ],
//     );
//   }

//   // Optimized helper method for floating action buttons
//   Widget _buildFloatingActionButton({
//     required IconData icon,
//     required String label,
//     required VoidCallback onPressed,
//   }) {
//     return SizedBox(
//       width: 120,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(icon, size: 20),
//         label: Text(label),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: secondaryColor,
//           foregroundColor: primaryColor,
//           padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
import '../helpers/database_helper.dart';
import '../widgets/chat_widget.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;

  NoteDetailScreen({required this.note});

  @override
  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen>
    with SingleTickerProviderStateMixin {
  // Define color constants to avoid duplication
  final Color primaryColor = Color.fromARGB(255, 123, 42, 185);
  final Color secondaryColor = Color.fromARGB(255, 238, 222, 255);
  
  late quill.QuillController _quillController;
  bool _showToolbar = false;
  bool _showChatbot = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Initialize Quill controller with markdown content
    final mdDocument = md.Document(encodeHtml: false);
    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
    final delta = mdToDelta.convert(widget.note.content);
    _quillController = quill.QuillController(
      document: quill.Document.fromDelta(delta),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void dispose() {
    _quillController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Function to convert Quill content to Markdown
  String _convertQuillToMarkdown() {
    final delta = _quillController.document.toDelta();
    final deltaToMarkdown = DeltaToMarkdown();
    return deltaToMarkdown.convert(delta);
  }

  // Function to save the updated note
  void _saveNote() async {
    String updatedContent = _convertQuillToMarkdown();
    Note updatedNote = Note(
      id: widget.note.id,
      title: widget.note.title,
      content: updatedContent,
      createdAt: widget.note.createdAt,
    );

    await DatabaseHelper.insertNote(updatedNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note saved successfully')),
    );
    Navigator.pop(context);
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Toggle chatbot method
  void _toggleChatbot() {
    setState(() {
      _showChatbot = !_showChatbot;
      if (_showChatbot) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.copy, color: primaryColor),
              title: Text('Copy'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: _quillController.document.toPlainText()));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notes copied to clipboard')),
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.save, color: primaryColor),
              title: Text('Save'),
              onTap: () {
                _saveNote();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: primaryColor),
              title: Text('Share'),
              onTap: () {
                Share.share(_quillController.document.toPlainText());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
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
                    color: primaryColor,
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
                  color: primaryColor,
                ),
                onPressed: () {
                  setState(() {
                    _showToolbar = !_showToolbar;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: primaryColor),
                onPressed: () => _showOptionsMenu(context),
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
                    child: quill.QuillToolbar.simple(
                        controller: _quillController),
                  ),
                ),

                // Editor area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: quill.QuillEditor.basic(
                      controller: _quillController,
                    ),
                  ),
                ),
                
                // Bottom spacing for floating button
                SizedBox(height: 20),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleChatbot,
            backgroundColor: primaryColor,
            child: Icon(
              _showChatbot ? Icons.close : Icons.chat,
              color: Colors.white,
            ),
          ),
        ),

        // Chatbot expanded view
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return _showChatbot
                ? Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: Opacity(
                        opacity: _animation.value,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              // Status bar height padding
                              SizedBox(height: MediaQuery.of(context).padding.top),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Chat Assistant',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: primaryColor,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: _toggleChatbot,
                                      color: primaryColor,
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Expanded(
                                // Use the ChatWidget here
                                child: ChatWidget(
                                  notesContent: _quillController.document.toPlainText(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          },
        ),
      ],
    );
  }
}