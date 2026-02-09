import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';

class SignUpProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  UserCredential? userCredential;

  Future<void> signUp({
    required BuildContext context,
    required TextEditingController email,
    required TextEditingController password,
    required TextEditingController userName,
  }) async {
    if (userName.text.trim().isEmpty) {
      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Username is required",
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.info_outline,
      );
      return;
    }
    if (email.text.trim().isEmpty) {
      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Email is required",
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.info_outline,
      );
      return;
    }

    if (password.text.trim().isEmpty) {
      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Password is required",
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.info_outline,
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Sign Up successful",
        backgroundColor: Colors.green,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = "Email already registered";
          break;
        case 'weak-password':
          message = "Password is too weak";
          break;
        case 'invalid-email':
          message = "Invalid email address";
          break;
        case 'network-request-failed':
          message = "No internet connection";
          break;
        default:
          message = "Sign up failed. Try again";
      }

      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: message,
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.info_outline,
      );
    } catch (e) {
      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Something went wrong. Please try again.",
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.info_outline,
      );
      log("Sign up error: $e");
    } finally {
      email.clear();
      password.clear();
      userName.clear();
      isLoading = false;
      notifyListeners();
    }
  }
}
