// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
// import 'package:markdown/markdown.dart' as md;
// import 'package:markdown_quill/markdown_quill.dart';
// import 'package:share_plus/share_plus.dart';
// import '../helpers/database_helper.dart';
// import '../models/note.dart';
// import '../widgets/chat_widget.dart';

// class GeneratedNotesScreen extends StatefulWidget {
//   final String notes;

//   GeneratedNotesScreen({required this.notes});

//   @override
//   _GeneratedNotesScreenState createState() => _GeneratedNotesScreenState();
// }

// class _GeneratedNotesScreenState extends State<GeneratedNotesScreen> 
//     with SingleTickerProviderStateMixin {
//   // Define color constants to avoid duplication
//   final Color primaryColor = Color.fromARGB(255, 123, 42, 185);
//   final Color secondaryColor = Color.fromARGB(255, 238, 222, 255);
  
//   late quill.QuillController _quillController;
//   bool _showToolbar = false; // To toggle toolbar visibility
//   bool _showChatbot = false;
  
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
    
//     final mdDocument = md.Document(encodeHtml: false);
//     final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
//     final delta = mdToDelta.convert(widget.notes);
//     _quillController = quill.QuillController(
//       document: quill.Document.fromDelta(delta),
//       selection: const TextSelection.collapsed(offset: 0),
//     );
//   }

//   Future<void> _askForNoteTitle() async {
//     String noteTitle = '';
//     await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Enter Note Title'),
//           content: TextField(
//             autofocus: true,
//             decoration: InputDecoration(hintText: 'Enter title here'),
//             onChanged: (value) {
//               noteTitle = value;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (noteTitle.isNotEmpty) {
//                   _saveNote(noteTitle);
//                   Navigator.of(context).pop();
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Please enter a title')),
//                   );
//                 }
//               },
//               child: Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Convert QuillController document content to markdown
//   String _getEditedContent() {
//     // Use the DeltaToMarkdown converter to get the current edited content
//     final deltaToMarkdown = DeltaToMarkdown();
//     return deltaToMarkdown.convert(_quillController.document.toDelta());
//   }

//   void _saveNote(String title) async {
//     // Use the edited content from QuillController instead of the original notes
//     String editedContent = _getEditedContent();
    
//     Note newNote = Note(
//       title: title,
//       content: editedContent, // Save the edited content
//       createdAt: DateTime.now(),
//     );
    
//     await DatabaseHelper.insertNote(newNote);
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Note saved successfully')),
//     );
//   }

//   @override
//   void dispose() {
//     _quillController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   void _showOptionsMenu(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Wrap(
//           children: [
//             ListTile(
//               leading: Icon(Icons.copy, color: primaryColor),
//               title: Text('Copy'),
//               onTap: () {
//                 Clipboard.setData(ClipboardData(text: _quillController.document.toPlainText()));
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Notes copied to clipboard')),
//                 );
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.save, color: primaryColor),
//               title: Text('Save'),
//               onTap: () {
//                 Navigator.pop(context);
//                 _askForNoteTitle();
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.share, color: primaryColor),
//               title: Text('Share'),
//               onTap: () {
//                 // Share the current edited content
//                 Share.share(_quillController.document.toPlainText());
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
  
//   // Toggle chatbot visibility
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
//             title: Text(
//               'Generated Notes',
//               style: TextStyle(
//                 fontFamily: 'Horizon',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: primaryColor,
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(_showToolbar ? Icons.keyboard_arrow_up : Icons.edit, 
//                     color: primaryColor),
//                 onPressed: () {
//                   setState(() {
//                     _showToolbar = !_showToolbar;
//                   });
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.more_vert, color: primaryColor),
//                 onPressed: () => _showOptionsMenu(context),
//               ),
//             ],
//           ),
//           body: SafeArea(
//             child: Column(
//               children: [
//                 // Divider
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Divider(),
//                 ),

//                 // Collapsible toolbar
//                 AnimatedContainer(
//                   duration: Duration(milliseconds: 300),
//                   height: _showToolbar ? 50 : 0,
//                   child: SingleChildScrollView(
//                     child: quill.QuillToolbar.simple(controller: _quillController),
//                   ),
//                 ),

//                 // Editor area
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: quill.QuillEditor.basic(
//                       controller: _quillController,
//                     ),
//                   ),
//                 ),
                
//                 // Bottom spacing for floating button
//                 SizedBox(height: 20),
//               ],
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: _toggleChatbot,
//             backgroundColor: primaryColor,
//             child: Icon(
//               _showChatbot ? Icons.close : Icons.chat,
//               color: Colors.white,
//             ),
//           ),
//         ),
        
//         // Chatbot expanded view
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
//                               SizedBox(height: MediaQuery.of(context).padding.top),
//                               Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
//                                 // Use the ChatWidget here - pass the current edited content
//                                 child: ChatWidget(
//                                   notesContent: _quillController.document.toPlainText(),
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
// }




import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:share_plus/share_plus.dart';
import '../helpers/database_helper.dart';
import '../models/note.dart';
import '../widgets/chat_widget.dart';

class GeneratedNotesScreen extends StatefulWidget {
  final String notes;

  GeneratedNotesScreen({required this.notes});

  @override
  _GeneratedNotesScreenState createState() => _GeneratedNotesScreenState();
}

class _GeneratedNotesScreenState extends State<GeneratedNotesScreen> 
    with SingleTickerProviderStateMixin {
  // Define color constants to avoid duplication
  final Color primaryColor = Color.fromARGB(255, 123, 42, 185);
  final Color secondaryColor = Color.fromARGB(255, 238, 222, 255);
  
  late quill.QuillController _quillController;
  bool _showToolbar = false; // To toggle toolbar visibility
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

  // Convert QuillController document content to markdown
  String _getEditedContent() {
    // Use the DeltaToMarkdown converter to get the current edited content
    final deltaToMarkdown = DeltaToMarkdown();
    return deltaToMarkdown.convert(_quillController.document.toDelta());
  }

  void _saveNote(String title) async {
    // Use the edited content from QuillController instead of the original notes
    String editedContent = _getEditedContent();
    
    Note newNote = Note(
      title: title,
      content: editedContent, // Save the edited content
      createdAt: DateTime.now(),
    );
    
    await DatabaseHelper.insertNote(newNote);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Note saved successfully')),
    );
  }

  // New method to navigate to home screen
  void _navigateToHome() {
    // NAVIGATION TO HOME SCREEN HAPPENS HERE
    // This will clear the navigation stack and set home as the only screen
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  void dispose() {
    _quillController.dispose();
    _animationController.dispose();
    super.dispose();
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
                Navigator.pop(context);
                _askForNoteTitle();
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: primaryColor),
              title: Text('Share'),
              onTap: () {
                // Share the current edited content
                Share.share(_quillController.document.toPlainText());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
  
  // Toggle chatbot visibility
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            // Removing default back button by setting automaticallyImplyLeading to false
            automaticallyImplyLeading: false,
            // Custom back button that navigates to home screen
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: primaryColor),
              onPressed: _navigateToHome, // USING THE HOME NAVIGATION METHOD HERE
            ),
            title: Text(
              'Generated Notes',
              style: TextStyle(
                fontFamily: 'Horizon',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_showToolbar ? Icons.keyboard_arrow_up : Icons.edit, 
                    color: primaryColor),
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
                    child: quill.QuillToolbar.simple(controller: _quillController),
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
                                // Use the ChatWidget here - pass the current edited content
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