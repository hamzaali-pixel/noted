// import 'package:audio_notes_app/screens/playback_screen.dart';
// import 'package:audio_notes_app/widgets/UI%20elements.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();

  
// }


// class _HomeScreenState extends State<HomeScreen> {
//   void _showNewNotesSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.6,
//           minChildSize: 0.4,
//           maxChildSize: 0.95,
//           builder: (context, scrollController) {
//            return Column(
//   children: [
//     // 👇 The drag handle bar
//     Padding(
//       padding: const EdgeInsets.only(top: 10),
//       child: Container(
//         width: 50,
//         height: 5,
//         decoration: BoxDecoration(
//           color: Colors.grey[400],
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     ),
//     const SizedBox(height: 10),
//     // 👇 The draggable content below
//     Expanded(
//       child: ListView(
//         controller: scrollController,
//         padding: const EdgeInsets.all(20),
//         children: _buildNoteTiles(),
//       ),
//     ),
//   ],
// );

//           },
//         );
//       },
//     );
//   }

//   List<Widget> _buildNoteTilesHscreen() {
//     return [
//       const SizedBox(height: 20),
//       _buildTile(
//         icon: Icons.book,
//         title: 'View Saved Notes',
//         subtitle: 'Access your note library',
//         onTap: () => Navigator.pushNamed(context, '/myNotesLibrary'),
//       ),
//     ];
//   }

//     List<Widget> _buildNoteTiles() {
//     return [
//       const SizedBox(height: 20),
//       _buildTile(
//         icon: Icons.mic,
//         title: 'Record Audio for Notes',
//         subtitle: 'Tap to start recording a new voice note',
//         onTap: () => Navigator.pushNamed(context, '/recorder'),
//       ),
//       const SizedBox(height: 20),
//       _buildTile(
//         icon: Icons.folder_open,
//         title: 'Upload from Library',
//         subtitle: 'Pick an existing audio file',
//         onTap:(){_pickFile(context);},
//       ),
//       const SizedBox(height: 20),
//       _buildTile(
//         icon: Icons.book,
//         title: 'View Saved Notes',
//         subtitle: 'Access your note library',
//         onTap:  () => Navigator.pushNamed(context, '/notesLibrary'),
//       ),
//     ];
//   }
// void _pickFile(BuildContext context) async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
//   );

//   if (result != null && result.files.single.path != null) {
//     String filePath = result.files.single.path!;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PlaybackScreen(filePath: filePath),
//       ),
//     );
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('No file selected')),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('NotEd', style: homeScreenFontStyle),
//                       const Text(
//                         'Your notes taking assistant',
//                         style: TextStyle(fontSize: 20, fontFamily: 'Jersey10'),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false,);
//                     },
//                     icon: const Icon(Icons.settings_outlined,
//                         color: Color.fromARGB(255, 123, 42, 185), size: 40),
//                   ),
//                 ],
//               ),
//               const Divider(),
//               const SizedBox(height: 170),
//               ..._buildNoteTilesHscreen(),
             
              
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         hoverElevation: 20,
//         backgroundColor: mainColor,
//         onPressed: () => _showNewNotesSheet(context),
//         label: const Text("New Notes",style: TextStyle(color: Colors.white),),
//         icon: const Icon(Icons.add,color: Colors.white,),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }

//   Widget _buildTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 238, 222, 255),
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 30, color: Color.fromARGB(255, 123, 42, 185)),
//             const SizedBox(width: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontFamily: 'Horizon',
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Color.fromARGB(255, 123, 42, 185),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       color: Colors.black87,
//                       fontSize: 13,
//                     ),
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

import 'package:audio_notes_app/screens/playback_screen.dart';
import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../helpers/database_helper.dart';
import '../models/note.dart';
import '../screens/note_detail_screen.dart';

String _formatDate(DateTime date) {
  return "${date.day}/${date.month}/${date.year}";
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Note>> _notesFuture;
  String _selectedFolder = "All Notes"; // Default folder
  List<String> _folders = ["All Notes", "Personal", "Work", "Ideas"]; // Default folders
  TextEditingController _newFolderController = TextEditingController();
  
  // Map of folder names to their respective icons
  final Map<String, IconData> _folderIcons = {
    "All Notes": Icons.notes,
    "Personal": Icons.person,
    "Work": Icons.work,
    "Ideas": Icons.lightbulb,
  };
  
  // Map to track which notes belong to which folders
  Map<int, String> _noteFolders = {};

  @override
  void initState() {
    super.initState();
    _notesFuture = DatabaseHelper.getAllNotes();
    // Load saved folders and settings
    _loadFolderData();
  }
  
  // Load folder data from SharedPreferences
  void _loadFolderData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load folders
    final foldersList = prefs.getStringList('folders');
    if (foldersList != null && foldersList.isNotEmpty) {
      setState(() {
        _folders = foldersList;
      });
    }
    
    // Load selected folder
    final savedSelectedFolder = prefs.getString('selectedFolder');
    if (savedSelectedFolder != null) {
      setState(() {
        _selectedFolder = savedSelectedFolder;
      });
    }
    
    // Load folder icons
    final folderIconsJson = prefs.getString('folderIcons');
    if (folderIconsJson != null) {
      final decodedIcons = json.decode(folderIconsJson) as Map<String, dynamic>;
      setState(() {
        decodedIcons.forEach((key, value) {
          // Convert the stored integer back to IconData
          _folderIcons[key] = IconData(value, fontFamily: 'MaterialIcons');
        });
      });
    }
    
    // Load note folder assignments
    final noteFoldersJson = prefs.getString('noteFolders');
    if (noteFoldersJson != null) {
      final decodedNoteFolders = json.decode(noteFoldersJson) as Map<String, dynamic>;
      setState(() {
        decodedNoteFolders.forEach((key, value) {
          // Convert string keys back to integers
          _noteFolders[int.parse(key)] = value.toString();
        });
      });
    }
  }

  // Save folder data to SharedPreferences
  void _saveFolderData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save folders list
    await prefs.setStringList('folders', _folders);
    
    // Save selected folder
    await prefs.setString('selectedFolder', _selectedFolder);
    
    // Save folder icons - convert IconData to something serializable
    final Map<String, int> serializableIcons = {};
    _folderIcons.forEach((key, iconData) {
      serializableIcons[key] = iconData.codePoint;
    });
    await prefs.setString('folderIcons', json.encode(serializableIcons));
    
    // Save note folder assignments - convert int keys to strings for JSON
    final Map<String, String> serializableNoteFolders = {};
    _noteFolders.forEach((key, value) {
      serializableNoteFolders[key.toString()] = value;
    });
    await prefs.setString('noteFolders', json.encode(serializableNoteFolders));
  }

  @override
  void dispose() {
    _newFolderController.dispose();
    super.dispose();
  }

  void _deleteFolder(String folderName) {
    // Don't allow deleting "All Notes" folder
    if (folderName == "All Notes") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('The "All Notes" folder cannot be deleted'))
      );
      return;
    }
    
    // Confirm delete
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Folder"),
          content: Text("Are you sure you want to delete '$folderName'? Notes in this folder will be moved to 'All Notes'."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Remove folder from list
                  _folders.remove(folderName);
                  
                  // If the deleted folder was selected, switch to "All Notes"
                  if (_selectedFolder == folderName) {
                    _selectedFolder = "All Notes";
                  }
                  
                  // Remove folder icon
                  _folderIcons.remove(folderName);
                  
                  // Update notes that were in this folder
                  _noteFolders.forEach((key, value) {
                    if (value == folderName) {
                      _noteFolders[key] = "All Notes";
                    }
                  });
                  
                  // Save the updated state
                  _saveFolderData();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Folder "$folderName" deleted'))
                );
              },
              child: Text("Delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(int id) async {
    await DatabaseHelper.deleteNote(id);
    setState(() {
      _notesFuture = DatabaseHelper.getAllNotes();
      // Also remove from folders mapping
      _noteFolders.remove(id);
      _saveFolderData(); // Save state
    });
  }

  void _shareNotes(String content) {
    Share.share(content);
  }

  void _addNewFolder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        IconData selectedIcon = Icons.folder;
        
        return AlertDialog(
          title: Text("New Folder"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _newFolderController,
                decoration: InputDecoration(
                  hintText: "Folder Name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Text("Choose Icon:"),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.folder),
                    onPressed: () => selectedIcon = Icons.folder,
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () => selectedIcon = Icons.favorite,
                  ),
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () => selectedIcon = Icons.star,
                  ),
                  IconButton(
                    icon: Icon(Icons.book),
                    onPressed: () => selectedIcon = Icons.book,
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_newFolderController.text.isNotEmpty &&
                    !_folders.contains(_newFolderController.text)) {
                  setState(() {
                    _folders.add(_newFolderController.text);
                    _folderIcons[_newFolderController.text] = selectedIcon;
                    _selectedFolder = _newFolderController.text;
                    _saveFolderData(); // Save state
                  });
                  _newFolderController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text("Create"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 123, 42, 185),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showNoteOptions(Note note) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.edit, color: Color.fromARGB(255, 123, 42, 185)),
                title: Text("Edit Note"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NoteDetailScreen(note: note),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Color.fromARGB(255, 123, 42, 185)),
                title: Text("Share Note"),
                onTap: () {
                  Navigator.pop(context);
                  _shareNotes(note.content);
                },
              ),
              ListTile(
                leading: Icon(Icons.folder, color: Color.fromARGB(255, 123, 42, 185)),
                title: Text("Move to Folder"),
                onTap: () {
                  Navigator.pop(context);
                  _showFolderSelection(note);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text("Delete Note"),
                onTap: () {
                  Navigator.pop(context);
                  _deleteNote(note.id!);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFolderSelection(Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Folder"),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _folders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_folderIcons[_folders[index]] ?? Icons.folder),
                  title: Text(_folders[index]),
                  onTap: () {
                    // Update the note's folder in our map
                    setState(() {
                      _noteFolders[note.id!] = _folders[index];
                      _saveFolderData(); // Save state
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Note moved to ${_folders[index]}')),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Filter notes based on selected folder
  List<Note> _filterNotesByFolder(List<Note> allNotes) {
    if (_selectedFolder == "All Notes") {
      return allNotes;
    } else {
      return allNotes.where((note) => 
        _noteFolders.containsKey(note.id) && 
        _noteFolders[note.id] == _selectedFolder
      ).toList();
    }
  }

  void _showNewNotesSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Column(
              children: [
                // The drag handle bar
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // The draggable content below
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: _buildNoteTiles(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> _buildNoteTiles() {
    return [
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.mic,
        title: 'Record Audio for Notes',
        subtitle: 'Tap to start recording a new voice note',
        onTap: () => Navigator.pushNamed(context, '/recorder'),
      ),
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.folder_open,
        title: 'Upload from Library',
        subtitle: 'Pick an existing audio file',
        onTap: () {_pickFile(context);},
      ),
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.picture_as_pdf,
        title: 'Generate notes from a PDF, Docx, or PPTX',
        subtitle: 'Upload and generate notes',
        onTap: () => Navigator.pushNamed(context, '/uploadPdf'),
      ),
    ];
  }

  void _pickFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'aac', 'm4a'],
    );

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PlaybackScreen(filePath: filePath),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  // Truncate folder name if it's too long
  String _truncateFolderName(String name) {
    return name.length > 10 ? name.substring(0, 7) + '...' : name;
  }

 Widget _buildFolderCircle(String folder) {
  bool isSelected = _selectedFolder == folder;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          shape: CircleBorder(),
          color: isSelected
              ? Color.fromARGB(255, 123, 42, 185)
              : Color.fromARGB(255, 238, 222, 255),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedFolder = folder;
                _saveFolderData(); // Save state
              });
            },
            onLongPress: () {
              _deleteFolder(folder);
            },
            customBorder: CircleBorder(),
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Icon(
                _folderIcons[folder] ?? Icons.folder,
                color: isSelected
                    ? Colors.white
                    : Color.fromARGB(255, 123, 42, 185),
                size: 30,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          _truncateFolderName(folder),
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? Color.fromARGB(255, 123, 42, 185)
                : Colors.black87,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildNoteTile(Note note) {
   String notePreview = note.content.replaceAll(RegExp(r'[#*]'), '').length > 100
    ? note.content.replaceAll(RegExp(r'[#*]'), '').substring(0, 23) + "..."
    : note.content.replaceAll(RegExp(r'[#*]'), '');


    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailScreen(note: note),
          ),
        ).then((_) {
          // Refresh notes list when returning from the detail screen
          setState(() {
            _notesFuture = DatabaseHelper.getAllNotes();
          });
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 222, 255),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.notes, size: 30, color: Color.fromARGB(255, 123, 42, 185)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontFamily: 'Horizon',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 123, 42, 185),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notePreview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(note.createdAt),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: const Color.fromARGB(255, 123, 42, 185),
              ),
              onPressed: () => _showNoteOptions(note),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            children: [
              // App header
                 Padding(
                   padding: const EdgeInsets.fromLTRB(18, 18, 18, 2),
                   child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('NotEd', style: homeScreenFontStyle),
                          const Text(
                            'Your notes taking assistant',
                            style: TextStyle(fontSize: 20, fontFamily: 'Jersey10'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false);
                        },
                        icon: const Icon(Icons.settings_outlined,
                            color: Color.fromARGB(255, 123, 42, 185), size: 40),
                      ),
                    ],
                                   ),
                 ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Divider(),
              ),
              
              // Folders row
              Container(
                height: 130,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    ..._folders.map((folder) => _buildFolderCircle(folder)),
                    // Add folder button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: _addNewFolder,
                            borderRadius: BorderRadius.circular(
                                30), // for consistent tap animation
                            child: Material(
                              color: Colors.grey[200],
                              shape:
                                  CircleBorder(), // Ensures ripple is circular
                              child: Container(
                                width: 80,
                                height: 80,
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  color: Color.fromARGB(255, 123, 42, 185),
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Divider(),
              ),
              
              // Notes list
              Expanded(
                child: FutureBuilder<List<Note>>(
                  future: _notesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No saved notes. Create one!'));
                    } else {
                      // Filter notes by the selected folder
                      final filteredNotes = _filterNotesByFolder(snapshot.data!);
                      
                      if (filteredNotes.isEmpty) {
                        return Center(
                          child: Text('No notes in this folder.'),
                        );
                      }
                      
                      return ListView.builder(
                        itemCount: filteredNotes.length,
                        padding: EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                          final note = filteredNotes[index];
                          return _buildNoteTile(note);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        hoverElevation: 20,
        backgroundColor: mainColor,
        onPressed: () => _showNewNotesSheet(context),
        label: const Text("New Notes", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 238, 222, 255),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Color.fromARGB(255, 123, 42, 185)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Horizon',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 123, 42, 185),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 13,
                    ),
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