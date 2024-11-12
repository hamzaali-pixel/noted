import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class GeneratedNotesScreen extends StatelessWidget {
  final String notes;

  GeneratedNotesScreen({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Banner Container at the top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color.fromARGB(255, 39, 36, 42), // Banner background color
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/icon.png', // Your image path
                    width: 100, // Adjust the width as needed
                    height: 100, // Adjust the height as needed
                  ),
                  const SizedBox(width: 10), // Spacing between image and text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                    children: [
                      const SizedBox(height: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Not',
                              style: TextStyle(
                                color: Color.fromARGB(255, 229, 196, 255), // Text color
                                fontSize: 32, // Font size for "Not"
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Ed.',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 147, 59, 198), // Text color for "Ed."
                                fontSize: 35, // Font size for "Ed."
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
                          color: Color.fromARGB(255, 235, 227, 227), // Text color
                          fontSize: 18, // Adjusted font size for readability
                          fontFamily: 'Horizon',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Main Content Positioned Below the Banner
          Positioned.fill(
            top: 140, // Adjust this value if needed to create space for the banner
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Markdown(
                      data: notes,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: notes));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Notes copied to clipboard')),
                          );
                        },
                        icon: Icon(Icons.copy),
                        label: Text('Copy'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Share.share(notes);
                        },
                        icon: Icon(Icons.share),
                        label: Text('Share'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
