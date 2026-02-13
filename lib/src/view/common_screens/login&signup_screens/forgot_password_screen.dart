import 'package:flutter/material.dart';
import 'package:healthcare/src/common_widgets/circular_progress_indicator.dart';
import 'package:healthcare/src/common_widgets/smooth_transitions.dart';
import 'package:healthcare/src/controller/auth_provider/forgot_password_provider.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

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
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
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
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
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
                      SizedBox(height: responsive.verticalPadding(20)),

                      _buildTitle(responsive),

                      SizedBox(height: responsive.verticalPadding(12)),

                      _buildDescription(responsive),

                      SizedBox(height: responsive.verticalPadding(24)),

                      _buildInputField(responsive),

                      SizedBox(height: responsive.verticalPadding(30)),

                      Consumer<ForgotPasswordProvider>(
                        builder: (context, provider, _) {
                          return _buildResetButton(responsive);
                        },
                      ),

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

  Widget _buildTitle(ResponsiveHelper responsive) {
    return Text(
      'Forgot Your Password?',
      style: TextStyle(
        fontSize: responsive.fontSize(24),
        fontWeight: FontWeight.bold,
        color: const Color(0xFF2E3E5C),
      ),
    );
  }

  Widget _buildDescription(ResponsiveHelper responsive) {
    return Text(
      'Enter your email or your phone number, we will send you confirmation code',
      style: TextStyle(
        fontSize: responsive.fontSize(15),
        color: Colors.grey[600],
        height: 1.5,
      ),
    );
  }

  Widget _buildInputField(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextFormField(
        controller: _controller,
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
          suffixIcon: Icon(
            Icons.check_circle,
            color: AppColors.midblue,
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

  Widget _buildResetButton(ResponsiveHelper responsive) {
    return SizedBox(
      height: responsive.buttonHeight(),
      child: ElevatedButton(
        onPressed: () async {
          FocusScope.of(context).unfocus();
          Provider.of<ForgotPasswordProvider>(
            context,
            listen: false,
          ).forgotPassword(context: context, email: _controller);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.midblue,
          foregroundColor: Colors.white,
          elevation: 0,
          disabledBackgroundColor: AppColors.midblue.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            Provider.of<ForgotPasswordProvider>(
              context,
              listen: false,
            ).isLoading
            ? CustomCircularProgressIndicator().circularProgressIndicator()
            : Text(
                'Reset Password',
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
