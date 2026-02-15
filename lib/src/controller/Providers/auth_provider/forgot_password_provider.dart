import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';
import 'package:healthcare/src/common_widgets/smooth_transitions.dart';

class ForgotPasswordProvider with ChangeNotifier {
  bool isLoading = false;

  Future<void> forgotPassword({
    required BuildContext context,
    required TextEditingController email,
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

    try {
      isLoading = true;
      notifyListeners();

      final FirebaseAuth auth = FirebaseAuth.instance;

      await auth.sendPasswordResetEmail(email: email.text.trim());

      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Password reset link sent to your email succesfully.",
        backgroundColor: Colors.green,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );
      SmoothNavigation.smoothPop(context);
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
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
      email.clear();
      isLoading = false;
      notifyListeners();
    }
  }
}
