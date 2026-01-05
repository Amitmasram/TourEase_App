import 'dart:async';

import 'package:TourEase/views/auth/login/login_screen.dart';
import 'package:TourEase/views/home/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:TourEase/viewmodels/user_prefrences.dart';


class VerifyEmailPage extends StatefulWidget {
  final String username;

  const VerifyEmailPage({Key? key, required this.username}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();

    // Check if email is already verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (isEmailVerified) {
      // If already verified (rare case), complete the setup
      _completeUserSetup();
    } else {
      // Send verification email
      sendVerificationEmail();

      // Check verification status periodically
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    // Call reload() to fetch the latest user data
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      await _completeUserSetup();
    }
  }

  Future<void> _completeUserSetup() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Now store user data in Firestore since they're verified
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': widget.username,
        'email': user.email,
        'emailVerified': true,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Set user as logged in
      await UserPreferences.setLoggedIn(true);

      // Navigate to main screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);

      // Allow resending after 60 seconds
      await Future.delayed(const Duration(seconds: 60));
      if (mounted) {
        setState(() => canResendEmail = true);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending verification email: $e'),
        ),
      );
    }
  }

  Future<void> _cancelRegistration() async {
    try {
      // Delete the user if they want to cancel registration
      await FirebaseAuth.instance.currentUser?.delete();
    } catch (e) {
      // If deletion fails (e.g., user needs to reauthenticate), just sign out
      await FirebaseAuth.instance.signOut();
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: _cancelRegistration,
            tooltip: 'Cancel Registration',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'A verification email has been sent to ${FirebaseAuth.instance.currentUser!.email}',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Text(
              'Please check your email (including spam folder) and click on the verification link to verify your account.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              icon: const Icon(Icons.email, size: 32),
              label: const Text(
                'Resend Email',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: canResendEmail ? sendVerificationEmail : null,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _cancelRegistration,
              child: const Text('Cancel Registration'),
            ),
          ],
        ),
      ),
    );
  }
}
