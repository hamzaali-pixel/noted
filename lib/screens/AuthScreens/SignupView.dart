// import 'package:audio_notes_app/screens/AuthScreens/emailVerficationView.dart';
// import 'package:audio_notes_app/screens/AuthScreens/loginView.dart';
// import 'package:audio_notes_app/widgets/snackbarWidget.dart';
// import 'package:audio_notes_app/widgets/UI%20elements.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class SignUpView extends StatefulWidget {
//   const SignUpView({super.key});

//   @override
//   State<SignUpView> createState() => _SignUpViewState();
// }

// class _SignUpViewState extends State<SignUpView> {
//   var errorCode;
//   bool _isObscured = true;
//   bool _isObscured2 = true;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmpasswordController = TextEditingController();

//   Future<void> signup() async {
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => emailVerifyView(),
//           ),
//           (_) => false);
//     } on FirebaseAuthException catch (e) {
//       print(e.code);
//       setState(() {
//         errorCode = e.code;
//       });
//       if (e.code == 'invalid-email') {
//         showSnackBar('Your email is invalid.', context);
//       } else if (e.code == 'password-does-not-meet-requirements') {
//         showSnackBar('Your password must have one special character.', context);
//       } else if (e.code == 'email-already-in-use') {
//         showSnackBar('Email already in use.', context);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 40),
//                   Text(
//                     'Create your account',
//                     style: mainAuthFontStyle,
//                   ),
//                   SizedBox(height: 40),
//                   // Email Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 4,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         hintText: 'Email',
//                         hintStyle: TextStyle(color: Colors.grey[400]),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 16,
//                         ),
//                         suffixIcon: Icon(
//                           Icons.email,
//                           color: Colors.grey[400],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   // Password Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 4,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       obscureText: _isObscured,
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         hintStyle: TextStyle(color: Colors.grey[400]),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isObscured ? Icons.visibility_off : Icons.visibility,
//                             color: Colors.grey[400],
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isObscured = !_isObscured;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 16),
//                   // Confirm Password Field
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           spreadRadius: 1,
//                           blurRadius: 4,
//                           offset: Offset(0, 1),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: _confirmpasswordController,
//                       obscureText: _isObscured2,
//                       decoration: InputDecoration(
//                         hintText: 'Confirm Password',
//                         hintStyle: TextStyle(color: Colors.grey[400]),
//                         suffixIcon: IconButton(
//                           icon: Icon(
//                             _isObscured2 ? Icons.visibility_off : Icons.visibility,
//                             color: Colors.grey[400],
//                           ),
//                           onPressed: () {
//                             setState(() {
//                               _isObscured2 = !_isObscured2;
//                             });
//                           },
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Sign Up Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 60,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_passwordController.text != _confirmpasswordController.text) {
//                           showSnackBar('Passwords do not match', context);
//                         } else {
//                           signup();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF8A2BE2), // Violet
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: const Text(
//                         'SIGN UP',
//                         style: TextStyle(
//                           fontSize: 35,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Jersey10',
//                           letterSpacing: 3,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
          
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         'Already have an account? ',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontSize: 14,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushAndRemoveUntil(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => LoginView(),
//                               ),
//                               (_) => false);
//                         },
//                         child: Text(
//                           'Login',
//                           style: TextStyle(
//                             color: Color(0xFF9370DB), // Medium purple
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// }
import 'package:audio_notes_app/screens/AuthScreens/emailVerficationView.dart';
import 'package:audio_notes_app/screens/AuthScreens/loginView.dart';
import 'package:audio_notes_app/widgets/snackbarWidget.dart';
import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var errorCode;
  bool _isObscured = true;
  bool _isObscured2 = true;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController = TextEditingController();

  Future<void> signup() async {
    try {
      // Create user with email and password in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      
      // Get the current timestamp for dateJoined
      final dateJoined = DateTime.now();
      
      // Save additional user data to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'dateJoined': dateJoined,
        'uid': userCredential.user!.uid,
      });

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => emailVerifyView(),
          ),
          (_) => false);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      setState(() {
        errorCode = e.code;
      });
      if (e.code == 'invalid-email') {
        showSnackBar('Your email is invalid.', context);
      } else if (e.code == 'password-does-not-meet-requirements') {
        showSnackBar('Your password must have one special character.', context);
      } else if (e.code == 'email-already-in-use') {
        showSnackBar('Email already in use.', context);
      }
    } catch (e) {
      print('Error: $e');
      showSnackBar('An error occurred during sign up.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    'Create your account',
                    style: mainAuthFontStyle,
                  ),
                  SizedBox(height: 40),
                  
                  // First Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'First Name',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Last Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Last Name',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: Icon(
                          Icons.person_outline,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      obscureText: _isObscured,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Confirm Password Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _confirmpasswordController,
                      obscureText: _isObscured2,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured2 ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey[400],
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured2 = !_isObscured2;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_passwordController.text != _confirmpasswordController.text) {
                          showSnackBar('Passwords do not match', context);
                        } else if (_firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty) {
                          showSnackBar('Please fill in all fields', context);
                        } else {
                          signup();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8A2BE2), // Violet
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'SIGN UP',
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
                  SizedBox(height: 20),
          
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
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
                          'Login',
                          style: TextStyle(
                            color: Color(0xFF9370DB), // Medium purple
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}