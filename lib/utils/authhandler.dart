import 'package:audio_notes_app/screens/AuthScreens/loginView.dart';
import 'package:audio_notes_app/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthHandler extends StatelessWidget {
  const AuthHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){

          return HomeScreen();
          }
          else{
            return const LoginView();
          //  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
          }
        },
      ); 
  }
}