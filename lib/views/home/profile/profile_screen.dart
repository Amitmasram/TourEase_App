import 'package:TourEase/views/home/profile/feedback.dart';
import 'package:TourEase/viewmodels/user_prefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/constants/colors.dart';
import '../../../core/helpers/helper.dart';

import 'package:TourEase/views/auth/login/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? AppColors.dark : AppColors.light,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context, dark),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSavedPlaces(dark),
                  const SizedBox(height: 24),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu,
                color: isDarkMode ? Colors.white : Colors.black),
            onPressed: () => _showDrawer(context, isDarkMode),
          ),
          Text(
            'Profile',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 40), // For balance
        ],
      ),
    );
  }

  Widget _buildSavedPlaces(bool isDarkMode) {
    return GestureDetector(
      onTap: () {
        // Navigate to Saved Places screen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]!.withOpacity(0.5)
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Saved Places',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildFeedback(bool isDarkMode) {
  //   return GestureDetector(
  //     onTap: () {
  //       // Navigate to Feedback screen
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         color: isDarkMode
  //             ? Colors.grey[800]!.withOpacity(0.5)
  //             : Colors.white.withOpacity(0.2),
  //         borderRadius: BorderRadius.circular(16),
  //       ),
  //       child: InkWell(
  //         onTap: () {
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => FeedbackScreen()));
  //         },
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(
  //               'Feedback',
  //               style: TextStyle(
  //                 color: isDarkMode ? Colors.white : Colors.black,
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             Icon(
  //               Icons.arrow_forward_ios,
  //               color: isDarkMode ? Colors.white : Colors.black,
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void _showDrawer(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.feedback_outlined,
                    size: 26,
                    color: isDarkMode ? Colors.white : Colors.black87),
                title: Text('Feedback',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87)),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen())),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.shieldHalved,
                    color: isDarkMode ? Colors.white : Colors.black87),
                title: Text('Privacy Policies',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87)),
                onTap: () => Navigator.pop(context),
              ),
                ListTile(
                leading: FaIcon(FontAwesomeIcons.envelope,
                    color: isDarkMode ? Colors.white : Colors.black87),
                title: Text('Contact us',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket,
                    color: isDarkMode ? Colors.white : Colors.black87),
                title: Text('LogOut',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await UserPreferences.clearLoginStatus();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
