import 'package:audio_notes_app/screens/AuthScreens/emailVerficationView.dart';
import 'package:audio_notes_app/screens/AuthScreens/loginView.dart';
import 'package:audio_notes_app/screens/Settings/settingsView.dart';
import 'package:audio_notes_app/screens/generated_notes_screen.dart';
import 'package:audio_notes_app/screens/home_screen.dart';
import 'package:audio_notes_app/screens/notes_library_screen.dart';
import 'package:audio_notes_app/screens/playback_screen.dart';
import 'package:audio_notes_app/screens/recording_screen.dart';
import 'package:audio_notes_app/screens/upload_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Return the MaterialApp widget for both cases (authenticated & unauthenticated)
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: snapshot.hasData ? '/' : '/'   , // Decide the initial route based on authentication state
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
            return null; // Return null if the route doesn't match
          },
          routes: {
            '/': (context) => HomeScreen(), // Authenticated user's home screen
            '/record': (context) => RecordingScreen(),
            '/upload': (context) => UploadScreen(),
            '/notesLibrary': (context) => NotesLibraryScreen(),
            '/login': (context) => LoginView(), 
            '/emailVerify': (context) => emailVerifyView(), 
            '/settings': (context) => SettingsScreen(),
            
            // Unauthenticated user's login screen
          },
        );
      },
    );
  }
}
