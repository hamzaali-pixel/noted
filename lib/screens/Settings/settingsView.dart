import 'package:audio_notes_app/widgets/UI%20elements.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false; // You'll replace this with actual theme logic later

  @override
  Widget build(BuildContext context) {
    final Color _mainColor = mainColor;
    final Color cardColor = const Color.fromARGB(255, 238, 222, 255);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
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
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false,);
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

            
            SizedBox(height: 15,),
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
            const SizedBox(height: 30),
            _buildSettingsTile(
              icon: Icons.person_outline,
              title: 'Account Settings',
              onTap: () {
                // TODO: Navigate to account settings screen
              },
              cardColor: cardColor,
              mainColor: _mainColor,
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
                // TODO: Apply theme change
              },
              cardColor: cardColor,
              mainColor: _mainColor,
            ),const SizedBox(height: 20),
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
            // const Spacer(),
            // Center(
            //   child: ElevatedButton.icon(
            //     onPressed: () async {
            //       try {
            //         await FirebaseAuth.instance.signOut();
            //         Navigator.pushNamedAndRemoveUntil(
            //             context, '/login', (route) => false);
            //       } catch (e) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text('Error signing out: $e')),
            //         );
            //       }
            //     },
            //     icon: Icon(Icons.logout, color: _mainColor),
            //     label: Text(
            //       'Logout',
            //       style: TextStyle(
            //         color: _mainColor,
            //         fontFamily: 'Horizon',
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: cardColor,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //     ),
            //   ),
            // )
          ],
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
