// 






import 'package:audio_notes_app/screens/AuthScreens/loginView.dart';
import 'package:audio_notes_app/widgets/snackbarWidget.dart';
import 'package:audio_notes_app/widgets/textStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class emailVerifyView extends StatefulWidget {
  const emailVerifyView({super.key});

  @override
  State<emailVerifyView> createState() => _emailVerifyViewState();
}

class _emailVerifyViewState extends State<emailVerifyView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Text(
                'Verify Your Email',
                style: mainAuthFontStyle,
              ),
            
              SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    await user?.sendEmailVerification();
                    showSnackBar('An Email is sent to your inbox.', context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8A2BE2), // Violet
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'SEND VERIFICATION EMAIL',
                    style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Jersey10',
                          letterSpacing: 3,
                        ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already verified? ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginView(),
                          ),
                          (_) => false);
                    },
                    child: Text(
                      'Login now',
                      style: TextStyle(
                        color: Color(0xFF9370DB), // Medium purple
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                width: 350,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6E0FA),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Color(0xFF8A2BE2),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.left,
                        'Check inbox/spam for the verification email and click the link to verify.',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}