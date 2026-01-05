import 'package:TourEase/viewmodels/user_prefrences.dart';
import 'package:TourEase/views/home/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/datasources/remote/auth_service.dart';
import '../views/auth/verify_email.dart';

class LoginViewModel extends ChangeNotifier {
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context, String email, String password) async {
    email = email.trim();
    password = password.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email and password are required.")),
      );
      return;
    }

    setLoading(true);

    try {
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        if (user.emailVerified) {
          await UserPreferences.setLoggedIn(true);
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        } else {
          String username = "";
          try {
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

            if (userDoc.exists && userDoc.data() != null) {
              Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
              username = userData['name'] ?? "";
            }
          } catch (e) {
            debugPrint("Error fetching user data: $e");
          }

          if (username.isEmpty) {
            username = email.split('@')[0];
          }

          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyEmailPage(username: username),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please verify your email before logging in.")),
            );
          }
        }
      } else {
          // If user is null but no exception was thrown, it's a generic failure
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login failed. Please check your credentials.")),
            );
          }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = "No user found with this email.";
          break;
        case 'wrong-password':
          message = "Invalid password for this account.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'user-disabled':
          message = "This user account has been disabled.";
          break;
        case 'network-request-failed':
          message = "Network error occurred. Please check your internet connection.";
          break;
        default:
          message = "An unknown error occurred.";
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${e.toString()}")),
        );
      }
    } finally {
      setLoading(false);
    }
  }
}
