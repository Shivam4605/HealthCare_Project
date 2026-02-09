import 'package:flutter/material.dart';
import 'package:healthcare/src/common_widgets/circular_progress_indicator.dart';
import 'package:healthcare/src/common_widgets/smooth_transitions.dart';
import 'package:healthcare/src/controller/auth_provider/login_provider.dart';
import 'package:healthcare/src/controller/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:healthcare/src/view/common_screens/login&signup_screens/forgot_password_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

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
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => ForgotPasswordScreen(),
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
    );
    debugPrint('Navigate to Forgot Password');
  }

  void _handleGoogleSignIn() {
    Provider.of<LoginProvider>(context, listen: false).signInWithGoogle(
      context: context,
      userType: Provider.of<UserInfoProvider>(
        context,
        listen: false,
      ).userModel.selectedRole,
    );
    debugPrint('Sign in with Google');
  }

  void _handleAppleSignIn() {
    debugPrint('Sign in with Apple');
  }

  void _handleFacebookSignIn() {
    debugPrint('Sign in with Facebook');
  }

  @override
  Widget build(BuildContext context) {
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
          'Login',
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: responsive.verticalPadding(30)),

                      _buildEmailField(responsive),

                      SizedBox(height: responsive.verticalPadding(16)),

                      _buildPasswordField(responsive),

                      SizedBox(height: responsive.verticalPadding(12)),

                      _buildForgotPassword(responsive),

                      SizedBox(height: responsive.verticalPadding(30)),

                      Consumer<LoginProvider>(
                        builder: (context, provider, _) {
                          return _buildLoginButton(responsive, provider);
                        },
                      ),

                      SizedBox(height: responsive.verticalPadding(20)),

                      SizedBox(height: responsive.verticalPadding(30)),

                      _buildOrDivider(responsive),

                      SizedBox(height: responsive.verticalPadding(30)),

                      _buildGoogleButton(responsive),
                      SizedBox(height: responsive.verticalPadding(12)),
                      _buildAppleButton(responsive),
                      SizedBox(height: responsive.verticalPadding(12)),
                      _buildFacebookButton(responsive),

                      SizedBox(height: responsive.verticalPadding(40)),
                    ],
                  ),
                ),
              ),
            ),
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

  Widget _buildForgotPassword(ResponsiveHelper responsive) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: AppColors.midblue,
            fontSize: responsive.fontSize(14),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
    ResponsiveHelper responsive,
    LoginProvider provider,
  ) {
    return SizedBox(
      height: responsive.buttonHeight(),
      child: ElevatedButton(
        onPressed: () {
          final loginProvider = Provider.of<LoginProvider>(
            context,
            listen: false,
          );
          FocusScope.of(context).unfocus();
          loginProvider.login(
            context: context,
            email: _emailController,
            password: _passwordController,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.midblue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Provider.of<LoginProvider>(context, listen: false).isLoading
            ? CustomCircularProgressIndicator().circularProgressIndicator()
            : Text(
                'Login',
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }

  Widget _buildOrDivider(ResponsiveHelper responsive) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.horizontalPadding(16),
          ),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: responsive.fontSize(14),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
      ],
    );
  }

  Widget _buildGoogleButton(ResponsiveHelper responsive) {
    return _buildSocialButton(
      responsive: responsive,
      onPressed: _handleGoogleSignIn,
      icon: Icons.g_mobiledata,
      label: 'Sign in with Google',
      iconColor: const Color(0xFF4285F4),
    );
  }

  Widget _buildAppleButton(ResponsiveHelper responsive) {
    return _buildSocialButton(
      responsive: responsive,
      onPressed: _handleAppleSignIn,
      icon: Icons.apple,
      label: 'Sign in with Apple',
      iconColor: Colors.black,
    );
  }

  Widget _buildFacebookButton(ResponsiveHelper responsive) {
    return _buildSocialButton(
      responsive: responsive,
      onPressed: _handleFacebookSignIn,
      icon: Icons.facebook,
      label: 'Sign in with Facebook',
      iconColor: const Color(0xFF1877F2),
    );
  }

  Widget _buildSocialButton({
    required ResponsiveHelper responsive,
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      height: responsive.buttonHeight(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.horizontalPadding(16),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                SizedBox(width: responsive.horizontalPadding(12)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: responsive.fontSize(15),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E3E5C),
                  ),
                ),
              ],
            ),
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
    if (isSmallScreen) return 50;
    if (isMediumScreen) return 54;
    return 56;
  }
}
