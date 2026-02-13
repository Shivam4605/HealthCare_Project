import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthcare/src/common_widgets/smooth_transitions.dart';
import 'package:healthcare/src/controller/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/util/app_color.dart' show AppColors;
import 'package:healthcare/src/view/common_screens/login&signup_screens/login_screen.dart';
import 'package:healthcare/src/view/common_screens/login&signup_screens/sign_up_screen.dart';
import 'package:provider/provider.dart';

class AuthSelectScreen extends StatefulWidget {
  const AuthSelectScreen({super.key});

  @override
  State<AuthSelectScreen> createState() => _AuthSelectScreenState();
}

class _AuthSelectScreenState extends State<AuthSelectScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _logoController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotateAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
  }

  void _startAnimations() {
    _logoController.forward();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _fadeController.forward();
        _slideController.forward();
      }
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => LoginScreen(),
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

    debugPrint('Navigate to Login Screen');
  }

  void _onSignUpPressed() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => SignUpScreen(),
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
    debugPrint('Navigate to Sign Up Screen');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = ResponsiveHelper(size);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.horizontalPadding(24),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            SmoothNavigation.smoothPop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
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
                        ),
                      ],
                    ),

                    const Spacer(flex: 2),

                    _buildAnimatedLogo(responsive),

                    SizedBox(height: responsive.verticalPadding(50)),

                    _buildContent(responsive),

                    SizedBox(height: responsive.verticalPadding(50)),

                    _buildButtons(responsive),

                    const Spacer(flex: 2),

                    _buildBottomIndicator(responsive),

                    SizedBox(height: responsive.verticalPadding(10)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo(ResponsiveHelper responsive) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Transform.rotate(
            angle: _logoRotateAnimation.value,
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: responsive.logoSize(),
            height: responsive.logoSize(),
            decoration: BoxDecoration(
              color: AppColors.midblue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/app_images/logo.svg',
                width: responsive.logoIconSize(),
                height: responsive.logoIconSize(),
                placeholderBuilder: (context) => Icon(
                  Icons.medical_services_rounded,
                  size: responsive.logoIconSize(),
                  color: AppColors.midblue,
                ),
              ),
            ),
          ),

          SizedBox(height: responsive.verticalPadding(16)),

          Text(
            'Medics+',
            style: TextStyle(
              fontSize: responsive.fontSize(32),
              fontWeight: FontWeight.bold,
              color: AppColors.midblue,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ResponsiveHelper responsive) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            Text(
              "Let's get started as a",
              style: TextStyle(
                fontSize: responsive.fontSize(28),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E3E5C),
              ),
            ),
            SizedBox(height: responsive.verticalPadding(10)),
            Text(
              Provider.of<UserInfoProvider>(
                context,
                listen: false,
              ).userModel.selectedRole,
              style: TextStyle(
                fontSize: responsive.fontSize(21),
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2E3E5C),
              ),
            ),

            SizedBox(height: responsive.verticalPadding(16)),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: responsive.horizontalPadding(20),
              ),
              child: Text(
                "Login to enjoy the features we've\nprovided, and stay healthy!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: responsive.fontSize(16),
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(ResponsiveHelper responsive) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildLoginButton(responsive),

              SizedBox(height: responsive.verticalPadding(16)),

              _buildSignUpButton(responsive),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(ResponsiveHelper responsive) {
    return SizedBox(
      width: double.infinity,
      height: responsive.buttonHeight(),
      child: ElevatedButton(
        onPressed: _onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.midblue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: AppColors.midblue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
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

  Widget _buildSignUpButton(ResponsiveHelper responsive) {
    return SizedBox(
      width: double.infinity,
      height: responsive.buttonHeight(),
      child: OutlinedButton(
        onPressed: _onSignUpPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.midblue,
          side: BorderSide(color: AppColors.lightblue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
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

  Widget _buildBottomIndicator(ResponsiveHelper responsive) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: responsive.indicatorWidth(),
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(2),
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

  double logoSize() {
    if (isSmallScreen) return 100;
    if (isMediumScreen) return 110;
    return 120;
  }

  double logoIconSize() {
    if (isSmallScreen) return 50;
    if (isMediumScreen) return 55;
    return 60;
  }

  double buttonHeight() {
    if (isSmallScreen) return 52;
    if (isMediumScreen) return 56;
    return 58;
  }

  double indicatorWidth() {
    if (isSmallScreen) return 100;
    if (isMediumScreen) return 120;
    return 134;
  }
}
