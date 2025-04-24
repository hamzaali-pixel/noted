import 'package:audio_notes_app/screens/AuthScreens/SignupView.dart';
import 'package:audio_notes_app/screens/home_screen.dart';
import 'package:audio_notes_app/widgets/snackbarWidget.dart';
import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscured = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
 

  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      User? user = FirebaseAuth.instance.currentUser;
      var isEmailVerified = user!.emailVerified;
      if (isEmailVerified == true) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (_) => false);
      } else {
        showSnackBar('Email not verified', context);
      }
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'user-not-found') {
        showSnackBar('User not found.', context);
      } else if (e.code == 'wrong-password') {
        showSnackBar('Wrong Password', context);
      } else if (e.code == 'invalid-email') {
        showSnackBar('This is an invalid email.', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SafeArea(

        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Text(
                    'Welcome to NotEd',
                    style: mainAuthFontStyle,
                  ),
                  
                  SizedBox(height: 30),
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
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          if (_emailController.text.isEmpty) {
                            showSnackBar('Enter email first to reset password', context);
                          } else {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailController.text);
                            showSnackBar('Password reset email sent', context);
                          }
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Color(0xFF9370DB), // Medium purple
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8A2BE2), // Violet
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child:const Text(
                        'LOGIN',
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
                        'Don\'t have an Account? ',
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
                                builder: (context) => SignUpView(),
                              ),
                              (_) => false);
                        },
                        child: Text(
                          'Sign up',
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




// import 'package:audio_notes_app/screens/AuthScreens/SignupView.dart';
// import 'package:audio_notes_app/screens/home_screen.dart';
// import 'package:audio_notes_app/utils/authhandler.dart';
// import 'package:audio_notes_app/widgets/snackbarWidget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class LoginView extends StatefulWidget {
//   const LoginView({super.key});

//   @override
//   State<LoginView> createState() => _LoginViewState();
// }

// class _LoginViewState extends State<LoginView> {
//     bool _isObscured = true;
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   void login ()async{
//     try {
//   await FirebaseAuth.instance.signInWithEmailAndPassword(
//     email: _emailController.text,
//     password: _passwordController.text,
//   );
//   User? user= FirebaseAuth.instance.currentUser;
//       var isEmailVerified = user!.emailVerified;
//       if (isEmailVerified == true) {
//         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (_)=>false);
//     } else {
//       showSnackBar('Email not verified',context);
//     }
//       }
//  on FirebaseAuthException catch (e) {
//   print(e.code);
//   if (e.code == 'user-not-found') {
//      showSnackBar('User not found.', context);
//   } else if (e.code == 'wrong-password') {
//     showSnackBar('Wrong Password', context);
//   }
//   else if (e.code == 'invalid-email') {
//     showSnackBar('This is an invalid email.', context);
//   }
// }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: Offset(0, 3),
//               ),
//             ],
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 height: MediaQuery.of(context).size.height * 0.008,
//                 padding: EdgeInsets.symmetric(vertical: 10.0),
//                 color: Color(0xfff3ce1d),
//               ),
//             Padding(
//               padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
//               child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 SizedBox(height: 10.0),
//                 const Text(
//                   "Login Panel",
//                   style: TextStyle(
//                     fontSize: 26.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Divider(thickness: 2.0),
//                 const Text(
//                   "Sign in to start your session",
//                   style: TextStyle(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 TextField(
//                   controller: _emailController,
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     suffixIcon: Icon(Icons.email),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20.0),
//                 TextField(
//                   obscureText: _isObscured,
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     suffixIcon:IconButton(icon:  Icon(Icons.visibility),onPressed: () {
//                         setState(() {
//                           _isObscured = !_isObscured;
//                         });
//                       },),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: ()async {
//                       if(_emailController.text.isEmpty){
//                         showSnackBar('Enter email first to reset password', context);
//                       }
//                       else{
//                          await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
//                          showSnackBar('Password reset email sent', context);
//                       }
                     
//                     },
//                     child: Text("I forgot my password?"),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpView(),), (_)=>false);
//                     },
//                     child: Text("Don't have an account?"),
//                   ),
//                 ),
//                 SizedBox(height: 10.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     login();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: Size(double.infinity, 50),
//                     backgroundColor: Color(0xfff3ce1d),
//                   ),
//                   child: Text(
//                     'Login',
//                     style: TextStyle(color: Colors.black,
//                     fontSize: 17,
//                     ),
//                   ),
//                 ),
//               ],
//                         ),
//             ),
//             ]
//           ),
//         ),
//       ),
//     );
//   }
// }
