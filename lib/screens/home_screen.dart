import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    // 👇 The drag handle bar
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
    // 👇 The draggable content below
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

  List<Widget> _buildNoteTilesHscreen() {
    return [
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.book,
        title: 'View Saved Notes',
        subtitle: 'Access your note library',
        onTap: () => Navigator.pushNamed(context, '/notesLibrary'),
      ),
    ];
  }

    List<Widget> _buildNoteTiles() {
    return [
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.mic,
        title: 'Record Audio for Notes',
        subtitle: 'Tap to start recording a new voice note',
        onTap: () => Navigator.pushNamed(context, '/record'),
      ),
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.folder_open,
        title: 'Upload from Library',
        subtitle: 'Pick an existing audio file',
        onTap: () => Navigator.pushNamed(context, '/upload'),
      ),
      const SizedBox(height: 20),
      _buildTile(
        icon: Icons.book,
        title: 'View Saved Notes',
        subtitle: 'Access your note library',
        onTap: () => Navigator.pushNamed(context, '/notesLibrary'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
          child: Column(
            children: [
              Row(
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
                      Navigator.pushNamedAndRemoveUntil(context, '/settings', (route) => false,);
                    },
                    icon: const Icon(Icons.settings_outlined,
                        color: Color.fromARGB(255, 123, 42, 185), size: 40),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 170),
              ..._buildNoteTilesHscreen(),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                icon: const Icon(Icons.logout,
                    color: Color.fromARGB(255, 123, 42, 185)),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Color.fromARGB(255, 123, 42, 185),
                    fontFamily: 'Horizon',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 238, 222, 255),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
        label: const Text("New Notes",style: TextStyle(color: Colors.white),),
        icon: const Icon(Icons.add,color: Colors.white,),
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
