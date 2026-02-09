import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';
import 'package:healthcare/src/controller/local_storage/user_credential_local.dart';
import 'package:healthcare/src/controller/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/view/doctor_module/doctor_home_screen.dart';
import 'package:healthcare/src/view/medical_module/medical_staff_home_screen.dart';
import 'package:healthcare/src/view/patient_module/patient_home_screen.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool isLoading = false;
  UserCredential? userCredential;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login({
    required BuildContext context,
    required TextEditingController email,
    required TextEditingController password,
  }) async {
    this.email;
    this.password;
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
      UserCredentials userCredentials = UserCredentials();
      await userCredentials.setUserCredentials(
        email: email.text.trim(),
        password: password.text.trim(),
        selectedRole: Provider.of<UserInfoProvider>(
          context,
          listen: false,
        ).userModel.selectedRole,
        uid: userCredential!.user!.uid,
        isLoggedIn: true,
      );

      if (Provider.of<UserInfoProvider>(
            context,
            listen: false,
          ).userModel.selectedRole ==
          'Patient') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => PatientHomeScreen(),
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
      } else if (Provider.of<UserInfoProvider>(
            context,
            listen: false,
          ).userModel.selectedRole ==
          'Doctor') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => DoctorHomeScreen(),
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
      } else if (Provider.of<UserInfoProvider>(
            context,
            listen: false,
          ).userModel.selectedRole ==
          ' Medical Staff') {
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) => MedicalStaffHomeScreen(),
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
      } else {
        log("Navigation Not Found");
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
          message = "Invalid Credentials";
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
      email.clear();
      password.clear();
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle({
    required BuildContext context,
    required String userType,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading = false;
        notifyListeners();
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredentials userCredentials = UserCredentials();
      userCredential = await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential!.user;

      final GoogleSignIn googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
      );

      if (user == null) {
        throw Exception('Failed to get user data');
      }

      log("Google Sign-In Success");
      log("Email: ${user.email}");
      log("UID: ${user.uid}");
      log("Display Name: ${user.displayName}");
      log("Photo URL: ${user.photoURL}");
      log("Role: $userType");

      if (context.mounted) {
        CommonSnackbar.showAnimatedSnackBar(
          context: context,
          message: "Welcome, ${user.displayName ?? 'User'}!",
          backgroundColor: const Color(0xFF4CAF50),
          durationSeconds: 2,
          textColor: Colors.white,
          icon: Icons.check_circle_outline,
        );

        if (userType == 'Patient') {
          await userCredentials.setUserCredentials(
            email: email.text.trim(),
            password: password.text.trim(),
            selectedRole: Provider.of<UserInfoProvider>(
              context,
              listen: false,
            ).userModel.selectedRole,
            uid: userCredential!.user!.uid,
            isLoggedIn: true,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => PatientHomeScreen()),
            (route) => false,
          );
        } else if (userType == 'Doctor') {
          await userCredentials.setUserCredentials(
            email: email.text.trim(),
            password: password.text.trim(),
            selectedRole: Provider.of<UserInfoProvider>(
              context,
              listen: false,
            ).userModel.selectedRole,
            uid: userCredential!.user!.uid,
            isLoggedIn: true,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => DoctorHomeScreen()),
            (route) => false,
          );
        } else if (userType == 'Medical Staff') {
          await userCredentials.setUserCredentials(
            email: email.text.trim(),
            password: password.text.trim(),
            selectedRole: Provider.of<UserInfoProvider>(
              context,
              listen: false,
            ).userModel.selectedRole,
            uid: userCredential!.user!.uid,
            isLoggedIn: true,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MedicalStaffHomeScreen()),
            (route) => false,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.code} - ${e.message}");

      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with the same email';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please try again';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google Sign-In is not enabled';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Invalid password';
          break;
        case 'network-request-failed':
          errorMessage = 'Network error. Please check your connection';
          break;
        default:
          errorMessage = e.message ?? 'Authentication failed';
      }

      if (context.mounted) {
        CommonSnackbar.showAnimatedSnackBar(
          context: context,
          message: errorMessage,
          backgroundColor: Colors.redAccent,
          durationSeconds: 3,
          textColor: Colors.white,
          icon: Icons.error_outline,
        );
      }
    } catch (e) {
      log("Unexpected Error: ${e.toString()}");

      if (context.mounted) {
        CommonSnackbar.showAnimatedSnackBar(
          context: context,
          message: "Something went wrong. Please try again",
          backgroundColor: Colors.redAccent,
          durationSeconds: 2,
          textColor: Colors.white,
          icon: Icons.info_outline,
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
