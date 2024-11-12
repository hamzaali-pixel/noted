// home_screen.dart
import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top banner with a different background color
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
                                color: Color.fromARGB(255, 229, 196, 255), // Change text color for better contrast
                                fontSize: 32, // Font size for "Not"
                                fontFamily: 'Horizon',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Ed.',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 147, 59, 198), // Same text color for "Ed."
                                fontSize: 35, // Smaller font size for "Ed."
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
                          color: Color.fromARGB(255, 235, 227, 227), // Change text color for better contrast
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
          // Centered Main Content
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Record or Upload Audio',
                    style: TextStyle(
                      color: Color.fromARGB(255, 123, 42, 185), // Change text color for better contrast
                      fontSize: 24,
                      fontFamily: 'Horizon',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Record Audio AnimatedButton
                  AnimatedButton(
                    icon: Icons.mic,
                    onPressed: () {
                      Navigator.pushNamed(context, '/record');
                    },
                  ),
                  const SizedBox(height: 30),
                  // Upload Audio Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/upload');
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Upload from Library'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: const Color.fromARGB(255, 238, 222, 255),
                    ),
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
