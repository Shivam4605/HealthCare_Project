import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:healthcare/src/util/app_assets.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:healthcare/src/view/common_screens/role_select_screen.dart';

class AdvancedOnboardingScreen extends StatefulWidget {
  const AdvancedOnboardingScreen({super.key});

  @override
  State<AdvancedOnboardingScreen> createState() =>
      _AdvancedOnboardingScreenState();
}

class _AdvancedOnboardingScreenState extends State<AdvancedOnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  final List<OnboardingContent> _pages = [
    OnboardingContent(
      imagePath: AppAssets.doctor1,
      title: 'Consult only with a doctor\nyou trust',
    ),
    OnboardingContent(
      imagePath: AppAssets.doctor2,
      title: 'Find a lot of specialist\ndoctors in one place',
    ),
    OnboardingContent(
      imagePath: AppAssets.doctor3,
      title: 'Get connect our Online\nConsultation',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _fadeController.forward(from: 0);
    _scaleController.forward(from: 0);
  }

  void prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToNextScreen();
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToNextScreen();
    }
  }

  void _skipOnboarding() {
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = ResponsiveHelper(size);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildSkipButton(responsive),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildPageContent(context, _pages[index], responsive);
                },
              ),
            ),
            _buildBottomNavigation(responsive),
          ],
        ),
      ),
    );
  }

  Widget _buildSkipButton(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.only(
        top: responsive.verticalPadding(8),
        right: responsive.horizontalPadding(20),
        left: responsive.horizontalPadding(20),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: _skipOnboarding,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.horizontalPadding(12),
              vertical: responsive.verticalPadding(8),
            ),
          ),
          child: Text(
            'Skip',
            style: TextStyle(
              fontSize: responsive.fontSize(16),
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    OnboardingContent content,
    ResponsiveHelper responsive,
  ) {
    return FadeTransition(
      opacity: _fadeController,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.horizontalPadding(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: responsive.verticalPadding(20)),
              _buildDoctorImage(content, responsive),
              SizedBox(height: responsive.verticalPadding(50)),
              _buildTitle(content, responsive),
              SizedBox(height: responsive.verticalPadding(40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorImage(
    OnboardingContent content,
    ResponsiveHelper responsive,
  ) {
    return Hero(
      tag: 'doctor_$_currentPage',
      child: Container(
        height: responsive.imageHeight(),
        width: responsive.imageWidth(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SvgPicture.asset(
            "assets/app_images/doctor1.svg",
            fit: BoxFit.contain,
            placeholderBuilder: (context) => _buildPlaceholderImage(responsive),
          ),
          // child: Image.asset("assets/app_images/7xm 5.png"),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage(ResponsiveHelper responsive) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF13BDAC).withOpacity(0.1),
            const Color(0xFF0C9688).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_hospital_outlined,
              size: responsive.iconSize(80),
              color: const Color(0xFF13BDAC).withOpacity(0.4),
            ),
            SizedBox(height: responsive.verticalPadding(12)),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: responsive.fontSize(16),
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(OnboardingContent content, ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding(10),
      ),
      child: Text(
        content.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: responsive.titleFontSize(),
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2E3E5C),
          height: 1.3,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding(24),
        vertical: responsive.verticalPadding(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPageIndicators(responsive),
          Row(
            children: [
              if (_currentPage > 0) _buildPrevButton(responsive),
              SizedBox(width: responsive.horizontalPadding(12)),
              _buildNextButton(responsive),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators(ResponsiveHelper responsive) {
    return Row(
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(right: responsive.horizontalPadding(6)),
          height: responsive.indicatorHeight(),
          width: _currentPage == index
              ? responsive.activeIndicatorWidth()
              : responsive.indicatorWidth(),
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.midblue
                : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(ResponsiveHelper responsive) {
    return InkWell(
      onTap: _nextPage,
      borderRadius: BorderRadius.circular(32),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: responsive.buttonSize(),
        height: responsive.buttonSize(),
        decoration: BoxDecoration(
          color: AppColors.midblue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightblue.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
          size: responsive.buttonIconSize(),
        ),
      ),
    );
  }

  Widget _buildPrevButton(ResponsiveHelper responsive) {
    return InkWell(
      onTap: prevPage,
      borderRadius: BorderRadius.circular(32),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: responsive.buttonSize(),
        height: responsive.buttonSize(),
        decoration: BoxDecoration(
          color: AppColors.midblue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightblue.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: responsive.buttonIconSize(),
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

  double titleFontSize() {
    if (isSmallScreen) return 20;
    if (isMediumScreen) return 22;
    return 24;
  }

  double imageHeight() {
    if (isShortScreen) return height * 0.4;
    if (isMediumHeight) return height * 0.45;
    return height * 0.48;
  }

  double imageWidth() {
    if (isSmallScreen) return width * 0.7;
    if (isMediumScreen) return width * 0.75;
    return width * 0.8;
  }

  double buttonSize() {
    if (isSmallScreen) return 56;
    if (isMediumScreen) return 60;
    return 64;
  }

  double buttonIconSize() {
    if (isSmallScreen) return 24;
    if (isMediumScreen) return 26;
    return 28;
  }

  double indicatorHeight() {
    if (isSmallScreen) return 6;
    return 8;
  }

  double indicatorWidth() {
    if (isSmallScreen) return 6;
    return 8;
  }

  double activeIndicatorWidth() {
    if (isSmallScreen) return 20;
    if (isMediumScreen) return 22;
    return 24;
  }

  double iconSize(double base) {
    if (isSmallScreen) return base * 0.8;
    if (isMediumScreen) return base * 0.9;
    return base;
  }
}

class OnboardingContent {
  final String imagePath;
  final String title;

  OnboardingContent({required this.imagePath, required this.title});
}
