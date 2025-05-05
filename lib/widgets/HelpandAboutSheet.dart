
import 'dart:ui';

import 'package:audio_notes_app/widgets/UI%20elements.dart' show mainColor;
import 'package:flutter/material.dart';

void showHelpAndAboutSheet(BuildContext Context) {
  showModalBottomSheet(
    context: Context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Pull down handle
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                
                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.all(20),
                    children: [
                      // App title
                      Center(
                        child: Text(
                          'NotEd',
                          style: TextStyle(
                            fontFamily: 'Jersey10',
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: mainColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // App logo
                      Image.asset(
                        'lib/assets/images/applogo_round.png',
                        width: 85,
                        height: 85,
                      ),

                      SizedBox(height: 30),
                      
                      // About section
                      _buildInfoSection(
                        title: 'About',
                        content: 'Audio Notes App is an innovative AI-powered application that '
                               'transforms voice recordings into intelligently organized notes. '
                               'Leveraging cutting-edge speech recognition and natural language '
                               'processing, it helps students and professionals capture and organize '
                               'their thoughts effortlessly.',
                        icon: Icons.info_outline,
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Developer section
                      _buildInfoSection(
                        title: 'Developer',
                        content: 'Syed Hamza Ali\nStudent at SEECS, NUST University',
                        icon: Icons.person_outline,
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Project info
                      _buildInfoSection(
                        title: 'Project',
                        content: 'Final Year Project (FYP)\nDeveloped in 2025',
                        icon: Icons.school_outlined,
                      ),
                      
                      SizedBox(height: 20),
                      
                      // Version info
                      _buildInfoSection(
                        title: 'Version',
                        content: 'Version 1.0.0',
                        icon: Icons.numbers,
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Close button
                      Center(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Horizon',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Helper method to build info sections
Widget _buildInfoSection({
  required String title,
  required String content,
  required IconData icon,
}) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 238, 222, 255),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: mainColor),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Horizon',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            fontFamily: 'Horizon',
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}