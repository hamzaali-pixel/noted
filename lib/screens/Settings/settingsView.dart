// import 'package:audio_notes_app/widgets/UI%20elements.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Added for Firestore

// class SettingsScreen extends StatefulWidget {
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   bool isDarkMode = false; // You'll replace this with actual theme logic later
//   bool _isLoading = true;
  
//   // User information controllers
//   final TextEditingController _firstNameController = TextEditingController();
//   final TextEditingController _lastNameController = TextEditingController();
//   String _email = '';
//   String _dateJoined = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
  
//   @override
//   void dispose() {
//     _firstNameController.dispose();
//     _lastNameController.dispose();
//     super.dispose();
//   }

//   // Load user data from Firestore
//   Future<void> _loadUserData() async {
//     try {
//       final User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         final userDoc = await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(currentUser.uid)
//             .get();
            
//         if (userDoc.exists) {
//           setState(() {
//             _firstNameController.text = userDoc['firstName'] ?? '';
//             _lastNameController.text = userDoc['lastName'] ?? '';
//             _email = userDoc['email'] ?? '';
//             _dateJoined = userDoc['dateJoined'] != null 
//                 ? _formatDate(userDoc['dateJoined'].toDate()) 
//                 : 'Unknown';
//             _isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       setState(() => _isLoading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error loading user data: $e')),
//       );
//     }
//   }

//   // Format date to a readable string
//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }

//   // Update user profile information
//   Future<void> _updateUserProfile() async {
//     try {
//       final User? currentUser = FirebaseAuth.instance.currentUser;
//       if (currentUser != null) {
//         await FirebaseFirestore.instance
//             .collection('Users')
//             .doc(currentUser.uid)
//             .update({
//           'firstName': _firstNameController.text,
//           'lastName': _lastNameController.text,
//         });
        
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile updated successfully')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error updating profile: $e')),
//       );
//     }
//   }

//   // Show change password dialog
//   void _showChangePasswordDialog() {
//     final TextEditingController _currentPasswordController = TextEditingController();
//     final TextEditingController _newPasswordController = TextEditingController();
//     final TextEditingController _confirmPasswordController = TextEditingController();
    
//     showDialog(
//   context: context,
//   builder: (context) => Dialog(
//     insetPadding: const EdgeInsets.all(20),
//     child: SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             'Edit Profile',
//             style: TextStyle(
//               fontFamily: 'Horizon',
//               color: mainColor,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           const SizedBox(height: 20),
//           TextField(
//             controller: _firstNameController,
//             decoration: const InputDecoration(
//               labelText: 'First Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: _lastNameController,
//             decoration: const InputDecoration(
//               labelText: 'Last Name',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Cancel', style: TextStyle(color: Colors.grey)),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     _firstNameController.text = _firstNameController.text;
//                     _lastNameController.text = _lastNameController.text;
//                   });
//                   Navigator.pop(context);
//                   _updateUserProfile();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: mainColor,
//                 ),
//                 child: const Text('Save', style: TextStyle(color: Colors.white)),
//               ),
//             ],
//           )
//         ],
//       ),
//     ),
//   ),
// );

//   }

//   // Show edit profile dialog
//   void _showEditProfileDialog() {
//     // Create temporary controllers with current values
//     final TextEditingController tempFirstName = TextEditingController(text: _firstNameController.text);
//     final TextEditingController tempLastName = TextEditingController(text: _lastNameController.text);
    
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           'Edit Profile',
//           style: TextStyle(
//             fontFamily: 'Horizon',
//             color: mainColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: tempFirstName,
//                 decoration: const InputDecoration(
//                   labelText: 'First Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: tempLastName,
//                 decoration: const InputDecoration(
//                   labelText: 'Last Name',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(
//               'Cancel',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 _firstNameController.text = tempFirstName.text;
//                 _lastNameController.text = tempLastName.text;
//               });
//               Navigator.pop(context);
//               _updateUserProfile();
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: mainColor,
//             ),
//             child: const Text('Save', style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Color _mainColor = mainColor;
//     final Color cardColor = const Color.fromARGB(255, 238, 222, 255);

//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: themeColor,
//         body: _isLoading
//             ? Center(child: CircularProgressIndicator(color: _mainColor))
//             : Padding(
//                 padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Stack(
//                       children: [
//                         // The circle background
//                         Container(
//                           width: 44,
//                           height: 44,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Color.fromARGB(255, 221, 202, 255), // background circle color
//                           ),
//                         ),
      
//                         // The icon on top of the circle
//                         Positioned.fill(
//                           child: Align(
//                             alignment: Alignment.center,
//                             child: IconButton(
//                               onPressed: () {
//                                 Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
//                               },
//                               icon: Icon(
//                                 Icons.arrow_back_ios_new_rounded,
//                                 size: 28, // slightly smaller to fit in the circle
//                                 color: mainColor, // the icon color
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
                    
//                     SizedBox(height: 15),
//                     const Text(
//                       'Settings',
//                       style: TextStyle(
//                         fontFamily: 'Jersey10',
//                         fontSize: 65,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF8A2BE2), // Violet
//                         height: 0.9,
//                       ),
//                     ),
                    
//                     // User Information Card
//                     const SizedBox(height: 30),
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: cardColor,
//                         borderRadius: BorderRadius.circular(15),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Colors.black12,
//                             blurRadius: 5,
//                             offset: Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 backgroundColor: _mainColor.withOpacity(0.2),
//                                 radius: 30,
//                                 child: Icon(
//                                   Icons.person,
//                                   size: 30,
//                                   color: _mainColor,
//                                 ),
//                               ),
//                               const SizedBox(width: 15),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${_firstNameController.text} ${_lastNameController.text}',
//                                       style: TextStyle(
//                                         fontFamily: 'Horizon',
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: _mainColor,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       _email,
//                                       style: TextStyle(
//                                         fontFamily: 'Horizon',
//                                         fontSize: 14,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       'Member since: $_dateJoined',
//                                       style: TextStyle(
//                                         fontFamily: 'Horizon',
//                                         fontSize: 12,
//                                         color: Colors.black54,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: _showEditProfileDialog,
//                                 icon: Icon(
//                                   Icons.edit,
//                                   color: _mainColor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 10),
//                           OutlinedButton(
//                             onPressed: _showChangePasswordDialog,
//                             style: OutlinedButton.styleFrom(
//                               side: BorderSide(color: _mainColor),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                             child: Text(
//                               'Change Password',
//                               style: TextStyle(
//                                 color: _mainColor,
//                                 fontFamily: 'Horizon',
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
      
//                     const SizedBox(height: 20),
//                     _buildSettingsTile(
//                       icon: Icons.info_outline,
//                       title: 'Help & About',
//                       onTap: () {
//                         // TODO: Show about/help info
//                       },
//                       cardColor: cardColor,
//                       mainColor: _mainColor,
//                     ),
//                     const SizedBox(height: 20),
//                     _buildSwitchTile(
//                       icon: Icons.dark_mode_outlined,
//                       title: 'Dark Mode',
//                       value: isDarkMode,
//                       onChanged: (val) {
//                         setState(() => isDarkMode = val);
                        
//                       },
//                       cardColor: cardColor,
//                       mainColor: _mainColor,
//                     ),
//                     const SizedBox(height: 20),
//                     _buildSettingsTile(
//                       icon: Icons.logout_rounded,
//                       title: 'Logout',
//                       onTap: () async {
//                         try {
//                           await FirebaseAuth.instance.signOut();
//                           Navigator.pushNamedAndRemoveUntil(
//                               context, '/login', (route) => false);
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Error signing out: $e')),
//                           );
//                         }
//                       },
//                       cardColor: cardColor,
//                       mainColor: Colors.red,
//                     ),
//                   ],
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildSettingsTile({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     required Color cardColor,
//     required Color mainColor,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(15),
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: cardColor,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: 28, color: mainColor),
//             const SizedBox(width: 20),
//             Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Horizon',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: mainColor,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSwitchTile({
//     required IconData icon,
//     required String title,
//     required bool value,
//     required Function(bool) onChanged,
//     required Color cardColor,
//     required Color mainColor,
//   }) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       decoration: BoxDecoration(
//         color: cardColor,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: const [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 5,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Icon(icon, size: 28, color: mainColor),
//           const SizedBox(width: 20),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontFamily: 'Horizon',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: mainColor,
//               ),
//             ),
//           ),
//           Switch(
//             value: value,
//             onChanged: onChanged,
//             activeColor: mainColor,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added for Firestore

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // You'll replace this with actual theme logic later
  bool _isLoading = true;
  
  // User information controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _email = '';
  String _dateJoined = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();
            
        if (userDoc.exists) {
          setState(() {
            _firstNameController.text = userDoc['firstName'] ?? '';
            _lastNameController.text = userDoc['lastName'] ?? '';
            _email = userDoc['email'] ?? '';
            _dateJoined = userDoc['dateJoined'] != null 
                ? _formatDate(userDoc['dateJoined'].toDate()) 
                : 'Unknown';
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    }
  }

  // Format date to a readable string
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Update user profile information
  Future<void> _updateUserProfile() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  // Show change password dialog
  void _showChangePasswordDialog() {
    final TextEditingController _currentPasswordController = TextEditingController();
    final TextEditingController _newPasswordController = TextEditingController();
    final TextEditingController _confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: 'Horizon',
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _firstNameController.text = _firstNameController.text;
                        _lastNameController.text = _lastNameController.text;
                      });
                      Navigator.pop(context);
                      _updateUserProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                    ),
                    child: const Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Show edit profile dialog - FIXED to handle keyboard overflow
  void _showEditProfileDialog() {
    // Create temporary controllers with current values
    final TextEditingController tempFirstName = TextEditingController(text: _firstNameController.text);
    final TextEditingController tempLastName = TextEditingController(text: _lastNameController.text);
    
    // Using a bottom sheet instead of a dialog to avoid keyboard overflow issues
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // This is important to make it responsive to keyboard
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontFamily: 'Horizon',
                    color: mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: tempFirstName,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: tempLastName,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _firstNameController.text = tempFirstName.text;
                          _lastNameController.text = tempLastName.text;
                        });
                        Navigator.pop(context);
                        _updateUserProfile();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      child: const Text('Save', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color _mainColor = mainColor;
    final Color cardColor = const Color.fromARGB(255, 238, 222, 255);

    return SafeArea(
      child: Scaffold(
        backgroundColor: themeColor,
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: _mainColor))
            : Padding(
                padding: const EdgeInsets.fromLTRB(25, 25, 25, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        // The circle background
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 221, 202, 255), // background circle color
                          ),
                        ),
      
                        // The icon on top of the circle
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 28, // slightly smaller to fit in the circle
                                color: mainColor, // the icon color
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 15),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontFamily: 'Jersey10',
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8A2BE2), // Violet
                        height: 0.9,
                      ),
                    ),
                    
                    // User Information Card
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: _mainColor.withOpacity(0.2),
                                radius: 30,
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: _mainColor,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_firstNameController.text} ${_lastNameController.text}',
                                      style: TextStyle(
                                        fontFamily: 'Horizon',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: _mainColor,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      _email,
                                      style: TextStyle(
                                        fontFamily: 'Horizon',
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Member since: $_dateJoined',
                                      style: TextStyle(
                                        fontFamily: 'Horizon',
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _showEditProfileDialog,
                                icon: Icon(
                                  Icons.edit,
                                  color: _mainColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: _showChangePasswordDialog,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: _mainColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Change Password',
                              style: TextStyle(
                                color: _mainColor,
                                fontFamily: 'Horizon',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
      
                    const SizedBox(height: 20),
                    _buildSettingsTile(
                      icon: Icons.info_outline,
                      title: 'Help & About',
                      onTap: () {
                        // TODO: Show about/help info
                      },
                      cardColor: cardColor,
                      mainColor: _mainColor,
                    ),
                    const SizedBox(height: 20),
                    _buildSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      value: isDarkMode,
                      onChanged: (val) {
                        setState(() => isDarkMode = val);
                        
                      },
                      cardColor: cardColor,
                      mainColor: _mainColor,
                    ),
                    const SizedBox(height: 20),
                    _buildSettingsTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      onTap: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => false);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error signing out: $e')),
                          );
                        }
                      },
                      cardColor: cardColor,
                      mainColor: Colors.red,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color cardColor,
    required Color mainColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: mainColor),
            const SizedBox(width: 20),
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
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required Color cardColor,
    required Color mainColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: mainColor),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Horizon',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: mainColor,
          ),
        ],
      ),
    );
  }
}