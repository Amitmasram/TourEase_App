import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../data/datasources/remote/auth_service.dart';
import '../../../views/auth/verify_email.dart';

class SignupViewModel extends ChangeNotifier {
  final FirebaseAuthService _auth = FirebaseAuthService();

  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> signUp(BuildContext context, String username, String email, String password) async {
    username = username.trim();
    email = email.trim();
    password = password.trim();

    if (email.isEmpty || password.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name, email, and password are required.")),
      );
      return;
    }

    setLoading(true);

    try {
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      if (user != null) {
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyEmailPage(username: username)),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'network-request-failed':
          message = "Network error occurred. Please check your internet connection.";
          break;
        case 'email-already-in-use':
          message = "The email address is already in use by another account.";
          break;
        case 'weak-password':
          message = "The password provided is too weak.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
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
          SnackBar(content: Text("Failed to sign up user: ${e.toString()}")),
        );
      }
    } finally {
      setLoading(false);
    }
  }
}
