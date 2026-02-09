import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:healthcare/src/common_widgets/circular_progress_indicator.dart';
import 'package:healthcare/src/common_widgets/smooth_transitions.dart';
import 'package:healthcare/src/controller/auth_provider/sign_up_provider.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _acceptedTerms = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _openTermsOfService() {
    debugPrint('Open Terms of Service');
  }

  void _openPrivacyPolicy() {
    debugPrint('Open Privacy Policy');
  }

  @override
  Widget build(BuildContext context) {
    log("Building SignUpScreen");
    final size = MediaQuery.of(context).size;
    final responsive = ResponsiveHelper(size);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 14),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  SmoothNavigation.smoothPop(context);
                },
                child: Container(
                  height: 40,
                  width: 40,

                  decoration: BoxDecoration(
                    color: AppColors.midblue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: responsive.fontSize(20),
                      color: AppColors.midblue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF2E3E5C),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.horizontalPadding(24),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: responsive.verticalPadding(30)),

                    _buildNameField(responsive),

                    SizedBox(height: responsive.verticalPadding(16)),

                    _buildEmailField(responsive),

                    SizedBox(height: responsive.verticalPadding(16)),

                    _buildPasswordField(responsive),

                    SizedBox(height: responsive.verticalPadding(20)),

                    _buildTermsCheckbox(responsive),

                    SizedBox(height: responsive.verticalPadding(30)),

                    Consumer(
                      builder: (context, signUpProvider, _) {
                        log("Call consumer oof the signup provider");
                        return _buildSignUpButton(responsive);
                      },
                    ),

                    SizedBox(height: responsive.verticalPadding(20)),

                    SizedBox(height: responsive.verticalPadding(40)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameField(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.words,
        style: TextStyle(
          fontSize: responsive.fontSize(15),
          color: const Color(0xFF2E3E5C),
        ),
        decoration: InputDecoration(
          hintText: 'Enter your name',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: responsive.fontSize(15),
          ),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.grey[400],
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.horizontalPadding(16),
            vertical: responsive.verticalPadding(16),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: responsive.fontSize(15),
          color: const Color(0xFF2E3E5C),
        ),
        decoration: InputDecoration(
          hintText: 'Enter your email',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: responsive.fontSize(15),
          ),
          prefixIcon: Icon(
            Icons.email_outlined,
            color: Colors.grey[400],
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.horizontalPadding(16),
            vertical: responsive.verticalPadding(16),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: TextStyle(
          fontSize: responsive.fontSize(15),
          color: const Color(0xFF2E3E5C),
        ),
        decoration: InputDecoration(
          hintText: 'Enter your password',
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: responsive.fontSize(15),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.grey[400],
            size: 22,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[400],
              size: 22,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.horizontalPadding(16),
            vertical: responsive.verticalPadding(16),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(ResponsiveHelper responsive) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _acceptedTerms,
            onChanged: (value) {
              setState(() {
                _acceptedTerms = value ?? false;
              });
            },
            activeColor: AppColors.midblue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(color: Colors.grey[400]!, width: 1.5),
          ),
        ),
        SizedBox(width: responsive.horizontalPadding(12)),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: responsive.verticalPadding(2)),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: responsive.fontSize(14),
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'I agree to the medidoc '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(
                      color: AppColors.midblue,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _openTermsOfService,
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                      color: AppColors.midblue,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = _openPrivacyPolicy,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(ResponsiveHelper responsive) {
    return SizedBox(
      height: responsive.buttonHeight(),
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          Provider.of<SignUpProvider>(context, listen: false).signUp(
            context: context,
            email: _emailController,
            password: _passwordController,
            userName: _nameController,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.midblue,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: const Color(0xFF13BDAC).withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Provider.of<SignUpProvider>(context, listen: false).isLoading
            ? CustomCircularProgressIndicator().circularProgressIndicator()
            : Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}

class ResponsiveHelper {
  final Size screenSize;

  ResponsiveHelper(this.screenSize);

  double get width => screenSize.width;
  double get height => screenSize.height;

  bool get isSmallScreen => width < 360;
  bool get isMediumScreen => width >= 360 && width < 400;
  bool get isLargeScreen => width >= 400;

  bool get isShortScreen => height < 700;
  bool get isMediumHeight => height >= 700 && height < 800;
  bool get isTallScreen => height >= 800;

  double horizontalPadding(double base) {
    if (isSmallScreen) return base * 0.8;
    if (isMediumScreen) return base * 0.9;
    return base;
  }

  double verticalPadding(double base) {
    if (isShortScreen) return base * 0.7;
    if (isMediumHeight) return base * 0.85;
    return base;
  }

  double fontSize(double base) {
    if (isSmallScreen) return base - 2;
    if (isMediumScreen) return base - 1;
    return base;
  }

  double buttonHeight() {
    if (isSmallScreen) return 52;
    if (isMediumScreen) return 56;
    return 58;
  }
}
