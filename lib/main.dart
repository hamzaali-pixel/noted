// lib/main.dart
import 'package:audio_notes_app/firebase_options.dart';
import 'package:audio_notes_app/screens/AuthScreens/emailVerficationView.dart';
import 'package:audio_notes_app/screens/AuthScreens/loginView.dart';
import 'package:audio_notes_app/screens/MyNotesLibrary.dart';
import 'package:audio_notes_app/screens/RecorderScreen.dart';
import 'package:audio_notes_app/screens/Settings/settingsView.dart';
import 'package:audio_notes_app/screens/generated_notes_screen.dart';
import 'package:audio_notes_app/screens/home_screen.dart';
import 'package:audio_notes_app/screens/notes_library_screen.dart';
import 'package:audio_notes_app/screens/playback_screen.dart';
import 'package:audio_notes_app/screens/recording_screen.dart';
import 'package:audio_notes_app/screens/upload_file_screen.dart';
import 'package:audio_notes_app/screens/upload_screen.dart';
import 'package:audio_notes_app/utils/authhandler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(AudioNotesApp());
}

class AudioNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AuthHandler(),
        debugShowCheckedModeBanner: false,
        title: 'Audio Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/home': (context) => HomeScreen(),
          '/record': (context) => RecordingScreen(),
          '/upload': (context) => UploadScreen(),
          '/notesLibrary': (context) => NotesLibraryScreen(),
          '/login': (context) => LoginView(),
          '/emailVerify': (context) => emailVerifyView(),
          '/settings': (context) => SettingsScreen(),
          '/recorder': (context) => RecorderScreen(),
          '/myNotesLibrary': (context) => MyNotesLibraryScreen(),
          '/uploadPdf': (context) => UploadFileScreen(),

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
        });
  }
}
