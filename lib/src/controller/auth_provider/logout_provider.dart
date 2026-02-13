import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';
import 'package:healthcare/src/view/common_screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> logout(BuildContext context) async {
    try {
      await _firebaseAuth.signOut();

      final GoogleSignIn googleSignIn = GoogleSignIn();

      await googleSignIn.signOut();

      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.clear();

      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => AdvancedOnboardingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            final tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (route) => false,
      );

      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Logout successful",
        backgroundColor: Colors.green,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );
      log("User logged out");
    } catch (e) {
      CommonSnackbar.showAnimatedSnackBar(
        context: context,
        message: "Logout failed",
        backgroundColor: Colors.redAccent,
        durationSeconds: 2,
        textColor: Colors.white,
        icon: Icons.check_circle_outline,
      );
    }
  }
}
