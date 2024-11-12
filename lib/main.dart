// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/recording_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/playback_screen.dart';
import 'screens/generated_notes_screen.dart';

void main() {
  runApp(AudioNotesApp());
}

class AudioNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/record': (context) => RecordingScreen(),
        '/upload': (context) => UploadScreen(),
        // PlaybackScreen and GeneratedNotesScreen will be handled via onGenerateRoute
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/playback') {
          final String filePath = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => PlaybackScreen(filePath: filePath),
          );
        } else if (settings.name == '/generatedNotes') {
          final String notes = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => GeneratedNotesScreen(notes: notes),
          );
        }
        return null;
      },
    );
  }
}
