import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';
import 'package:healthcare/src/controller/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/view/patient_module/home_screen.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;
  UserCredential? userCredential;

  Future<void> login({
    required BuildContext context,
    required TextEditingController email,
    required TextEditingController password,
  }) async {
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
      userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      email.clear();
      password.clear();
      if (Provider.of<UserInfoProvider>(
            context,
            listen: false,
          ).userModel.selectedRole ==
          'Patient') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false,
        );
        log("User role is not selected");
      } else if (Provider.of<UserInfoProvider>(
            context,
            listen: false,
          ).userModel.selectedRole ==
          'Doctor') {
        log("Doctor role is selected");
      } else {
        log("User role is not selected");
      }
      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Login successful",
        backgroundColor: Colors.green,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );

      log("User logged in: ${userCredential?.user?.email}");
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = "Invalid email address";
          break;
        case 'user-not-found':
          message = "User not found";
          break;
        case 'wrong-password':
          message = "Incorrect password";
          break;
        case 'network-request-failed':
          message = "No internet connection";
          break;
        default:
          message = "Login failed";
      }

      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: message,
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.info_outline,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
