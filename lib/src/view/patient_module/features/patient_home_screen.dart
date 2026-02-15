import 'dart:async';
import 'package:flutter/material.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/logout_provider.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:healthcare/src/view/patient_module/features/drawar_section_screen/favoriets_screen.dart';
import 'package:healthcare/src/view/patient_module/features/drawar_section_screen/notification_screen.dart';
import 'package:healthcare/src/view/patient_module/features/drawar_section_screen/patient_profile_screen.dart';

import 'package:healthcare/src/view/patient_module/features/drawar_section_screen/pharmacy_cart_screen.dart';

import 'package:healthcare/src/view/patient_module/features/generic_screens/drawer_screen.dart';

import 'package:healthcare/src/view/patient_module/features/generic_screens/models_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _animationController;
  late AnimationController _headerAnimationController;
  late AnimationController _fabAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _headerScaleAnimation;
  late final AnimationController _pulseController;
  late final AnimationController _slideController;

  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;
  bool _isLoading = false;
  bool _showLoading = false;
  late final List<PromoModel> _infinitePromos;

  final String _userName = 'John Doe';
  final String _userEmail = 'john.doe@email.com';
  final int _favoriteCount = 3;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoPlay();
    _showLoadingIndicator();

    _infinitePromos = List.from(_promos)
      ..addAll(_promos)
      ..addAll(_promos);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_carouselController.hasClients) {
        _carouselController.jumpToPage(_promos.length);
      }
    });

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  void _showLoadingIndicator() {
    setState(() {
      _showLoading = true;
    });

    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _headerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
    _headerAnimationController.forward();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _fabAnimationController.forward();
    });
  }

  void _startAutoPlay() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_carouselController.hasClients && mounted) {
        final nextPage = _carouselController.page!.toInt() + 1;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _headerAnimationController.dispose();
    _fabAnimationController.dispose();
    _carouselController.dispose();
    _carouselTimer?.cancel();
    _pulseController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handleDrawerItem(String item) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;

      switch (item) {
        case 'profile':
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  PatientProfileScreen(isArrowBack: true),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    var scaleTween = Tween<double>(
                      begin: 0.3,
                      end: 1.0,
                    ).chain(CurveTween(curve: Curves.easeOutCubic));

                    var fadeTween = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).chain(CurveTween(curve: Curves.easeIn));

                    return FadeTransition(
                      opacity: animation.drive(fadeTween),
                      child: ScaleTransition(
                        scale: animation.drive(scaleTween),
                        child: child,
                      ),
                    );
                  },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
          break;
        case 'favorites':
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const PatientFavoritesScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    var scaleTween = Tween<double>(
                      begin: 0.3,
                      end: 1.0,
                    ).chain(CurveTween(curve: Curves.easeOutCubic));

                    var fadeTween = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).chain(CurveTween(curve: Curves.easeIn));

                    return FadeTransition(
                      opacity: animation.drive(fadeTween),
                      child: ScaleTransition(
                        scale: animation.drive(scaleTween),
                        child: child,
                      ),
                    );
                  },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
          break;
        case 'Pharmacy Cart':
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const PharmacyCartScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    var scaleTween = Tween<double>(
                      begin: 0.3,
                      end: 1.0,
                    ).chain(CurveTween(curve: Curves.easeOutCubic));

                    var fadeTween = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).chain(CurveTween(curve: Curves.easeIn));

                    return FadeTransition(
                      opacity: animation.drive(fadeTween),
                      child: ScaleTransition(
                        scale: animation.drive(scaleTween),
                        child: child,
                      ),
                    );
                  },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
          break;
        case 'history':
        case 'prescriptions':
        case 'payments':
        case 'settings':
        case 'help':
          break;
        case 'logout':
          _showLogoutDialog();
          break;
      }
    });
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Dialog(
          elevation: 24,
          insetAnimationDuration: const Duration(milliseconds: 300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, scale, child) {
              final clampedScale = scale.clamp(0.0, 1.0);
              return Transform.scale(scale: clampedScale, child: child);
            },
            child: Container(
              width: 340,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Color(0xFFF8F9FF)],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            final clampedValue = value.clamp(0.0, 1.0);
                            return Container(
                              width: 100 + (clampedValue * 20),
                              height: 100 + (clampedValue * 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(
                                  (0.1 * (1 - clampedValue * 0.3)).clamp(
                                    0.0,
                                    1.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: const SweepGradient(
                              colors: [
                                Color(0xFFFF6B6B),
                                Color(0xFFEE5A6F),
                                Color(0xFFFF8E8E),
                                Color(0xFFFF6B6B),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.power_settings_new_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Text(
                    'Ready to Leave?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Are you sure you want to logout from your account?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF13BDAC).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF13BDAC).withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF13BDAC).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.info_rounded,
                            size: 16,
                            color: Color(0xFF13BDAC),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'You\'ll need to login again to continue',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF2E3E5C),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.grey[300]!,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Text(
                            'Stay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                Provider.of<LogoutProvider>(
                                  context,
                                  listen: false,
                                ).logout(context);
                                Navigator.pop(dialogContext);
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTabSelected() {
    setState(() {
      _showLoading = true;
    });

    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  void _handlePromoTap(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_promos[index].title),
        backgroundColor: _promos[index].color1,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AdvancedDrawerWrapper(
      onHomeTap: () {},
      onItemTap: _handleDrawerItem,
      userName: _userName,
      userEmail: _userEmail,
      favoriteCount: _favoriteCount,
      child: _showLoading
          ? _buildLoadingScreen()
          : RefreshIndicator(
              onRefresh: _handleRefresh,
              color: AppColors.midblue,
              child: Container(
                color: Colors.grey[50],
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        _buildSliverAppBar(),
                        _buildSearchBar(),
                        _buildCategories(),
                        _buildCarouselSlider(),
                        _buildQuickActions(),
                        _buildTopDoctorsSection(),
                        _buildHealthArticlesSection(),
                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 100),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _headerScaleAnimation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.midblue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.medical_services_rounded,
                size: 60,
                color: AppColors.midblue,
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Loading Health Data',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3E5C),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Preparing your personalized experience...',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              children: [
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.midblue.withOpacity(0.2),
                    ),
                    strokeWidth: 4,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.midblue,
                    ),
                    strokeWidth: 4,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildLoadingDots(),
        ],
      ),
    );
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 500 + (index * 200)),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            final clampedValue = value.clamp(0.0, 1.0);
            return Opacity(
              opacity: clampedValue,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.midblue,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverToBoxAdapter(
      child: ScaleTransition(
        scale: _headerScaleAnimation,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) {
                  final wrapperState = context
                      .findAncestorStateOfType<AdvancedDrawerWrapperState>();
                  return GestureDetector(
                    onTap: () => wrapperState?.handleMenuButtonPressed(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.midblue.withOpacity(0.1),
                            AppColors.midblue.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.midblue.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.menu_rounded,
                        color: AppColors.midblue,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              const Column(
                children: [
                  Text(
                    'Find your desire',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  Text(
                    'health solution',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const NotificationScreen(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                            var scaleTween = Tween<double>(
                              begin: 0.6,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeOutCubic));

                            var fadeTween = Tween<double>(
                              begin: 0.0,
                              end: 1.0,
                            ).chain(CurveTween(curve: Curves.easeIn));

                            return FadeTransition(
                              opacity: animation.drive(fadeTween),
                              child: ScaleTransition(
                                scale: animation.drive(scaleTween),
                                child: child,
                              ),
                            );
                          },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );

                  // LocalNotificationService.showNotification(
                  //   title: "Working ✅",
                  //   body: "Notifications working correctly",
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.notifications_rounded,
                        color: Color(0xFF2E3E5C),
                        size: 24,
                      ),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "3",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Hero(
          tag: 'search_bar',
          child: GestureDetector(
            onTap: _handleTabSelected,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.midblue.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search doctor, drugs, articles...',
                    hintStyle: TextStyle(
                      color: Color(0xFFB0B0B0),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.midblue,
                      size: 24,
                    ),
                    suffixIcon: Icon(
                      Icons.tune_rounded,
                      color: AppColors.midblue,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                  enabled: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      CategoryItem(
        icon: Icons.medical_services_rounded,
        label: 'Doctor',
        color: AppColors.midblue,
        gradient: const LinearGradient(
          colors: [Color(0xFF13BDAC), Color(0xFF0C9688)],
        ),
      ),
      CategoryItem(
        icon: Icons.medication_rounded,
        label: 'Pharmacy',
        color: const Color(0xFFFF6B6B),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
        ),
      ),
      CategoryItem(
        icon: Icons.local_hospital_rounded,
        label: 'Hospital',
        color: const Color(0xFF4ECDC4),
        gradient: const LinearGradient(
          colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
        ),
      ),
      CategoryItem(
        icon: Icons.local_shipping_rounded,
        label: 'Ambulance',
        color: const Color(0xFFFFA07A),
        gradient: const LinearGradient(
          colors: [Color(0xFFFFA07A), Color(0xFFFF6347)],
        ),
      ),
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + (index * 100)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  final clampedValue = value.clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: clampedValue,
                    child: GestureDetector(
                      onTap: _handleTabSelected,
                      child: _buildCategoryItem(categories[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(CategoryItem category) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              gradient: category.gradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: category.color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(category.icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            category.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3E5C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF13BDAC).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_offer_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Special Offers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E3E5C),
                      ),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      ScaleTransition(
                        scale: Tween<double>(
                          begin: 0.8,
                          end: 1.2,
                        ).animate(_pulseController),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 200,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ),

                PageView.builder(
                  controller: _carouselController,
                  onPageChanged: (index) {
                    setState(() {
                      if (index == 0) {
                        _carouselController.jumpToPage(_promos.length);
                      } else if (index == _infinitePromos.length - 1) {
                        _carouselController.jumpToPage(_promos.length - 1);
                      } else {
                        _currentCarouselIndex = index % _promos.length;
                      }
                    });
                  },
                  itemCount: _infinitePromos.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final actualIndex = index % _promos.length;
                    final isCenter =
                        index % _promos.length == _currentCarouselIndex;

                    return AnimatedBuilder(
                      animation: _carouselController,
                      builder: (context, child) {
                        double scale = 1.0;
                        double opacity = 1.0;

                        if (_carouselController.hasClients) {
                          final position = _carouselController.page ?? 0;
                          final distance = (index - position).abs();

                          if (distance <= 1) {
                            scale = 1.0 - (distance * 0.15);
                            opacity = 1.0;
                          } else {
                            scale = 0.7;
                            opacity = 0.5;
                          }
                        }

                        return GestureDetector(
                          onTap: () => _handlePromoTap(actualIndex),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isCenter ? 0 : 8,
                            ),
                            child: Transform.scale(
                              scale: scale,
                              child: Opacity(
                                opacity: opacity,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutCubic,
                                  margin: EdgeInsets.only(
                                    top: isCenter ? 0 : 10,
                                    bottom: isCenter ? 0 : 10,
                                  ),
                                  child: _buildEnhancedPromoCard(
                                    _promos[actualIndex],
                                    isCenter,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          _buildEnhancedIndicators(),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEnhancedPromoCard(PromoModel promo, bool isCenter) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [promo.color1, promo.color2],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: promo.color1.withOpacity(isCenter ? 0.4 : 0.2),
            blurRadius: isCenter ? 25 : 15,
            offset: const Offset(0, 8),
          ),
          if (isCenter)
            BoxShadow(
              color: Colors.white.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: -5,
            ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: -10,
            bottom: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          Positioned(
            right: 10,
            bottom: 10,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.9, end: 1.1),
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: 0.15,
                    child: Icon(promo.icon, size: 70, color: Colors.white),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_offer_rounded,
                        size: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'LIMITED',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFFFF9C4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: Text(
                    promo.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  promo.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                if (isCenter)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.5 * value),
                                blurRadius: 15,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () =>
                                _handlePromoTap(_promos.indexOf(promo)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: promo.color1,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  promo.buttonText,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_promos.length, (index) {
        final isSelected = _currentCarouselIndex == index;

        return GestureDetector(
          onTap: () {
            _carouselController.animateToPage(
              index + _promos.length,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isSelected ? 32 : 8,
            height: 8,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
                    )
                  : null,
              color: isSelected ? null : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF13BDAC).withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }

  Widget _buildPromoCard(PromoModel promo) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [promo.color1, promo.color2],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: promo.color1.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(promo.icon, size: 150, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      promo.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _handleTabSelected,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: promo.color1,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    promo.buttonText,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarouselIndicators(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _currentCarouselIndex == index ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentCarouselIndex == index
                ? AppColors.midblue
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildQuickActions() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _handleTabSelected,
                child: _buildQuickActionCard(
                  icon: Icons.videocam_rounded,
                  title: 'Video Call',
                  color: const Color(0xFF6B5CE7),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _handleTabSelected,
                child: _buildQuickActionCard(
                  icon: Icons.chat_bubble_rounded,
                  title: 'Chat',
                  color: const Color(0xFF13BDAC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E3E5C),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopDoctorsSection() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Top Doctor',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C),
                  ),
                ),
                TextButton(
                  onPressed: _handleTabSelected,
                  child: const Text(
                    'See all',
                    style: TextStyle(
                      color: AppColors.midblue,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 230,
            child: _isLoading
                ? _buildDoctorShimmer()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _topDoctors.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: _handleTabSelected,
                        child: _buildDoctorCard(_topDoctors[index], index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 700 + (index * 150)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final clampedValue = value.clamp(0.0, 1.0);
        return Transform.scale(scale: clampedValue, child: child);
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, AppColors.midblue.withOpacity(0.02)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.midblue.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.midblue.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.midblue.withOpacity(0.2),
                    AppColors.midblue.withOpacity(0.05),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.midblue.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    image: doctor.imageUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(doctor.imageUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: doctor.imageUrl.isEmpty
                      ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                doctor.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3E5C),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              doctor.specialty,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.midblue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Color(0xFFFFB800),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    doctor.rating.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    doctor.distance,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthArticlesSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Health article',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),
                  TextButton(
                    onPressed: _handleTabSelected,
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        color: AppColors.midblue,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ..._healthArticles.asMap().entries.map((entry) {
              return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(milliseconds: 600 + (entry.key * 150)),
                builder: (context, value, child) {
                  final clampedValue = value.clamp(0.0, 1.0);
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - clampedValue)),
                    child: Opacity(opacity: clampedValue, child: child),
                  );
                },
                child: GestureDetector(
                  onTap: _handleTabSelected,
                  child: _buildArticleCard(entry.value),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard(ArticleModel article) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[200]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.midblue.withOpacity(0.2),
                    AppColors.midblue.withOpacity(0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.article_rounded,
                size: 45,
                color: AppColors.midblue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.midblue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      article.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.midblue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E3E5C),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        article.date,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.bookmark_outline_rounded,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<PromoModel> _promos = [
  PromoModel(
    title: 'Early protection for\nyour family health',
    description: 'Get 20% discount for first consultation',
    buttonText: 'Learn more',
    color1: const Color(0xFF13BDAC),
    color2: const Color(0xFF0C9688),
    icon: Icons.family_restroom_rounded,
  ),
  PromoModel(
    title: 'Free Health\nCheckup',
    description: 'Book your annual checkup today',
    buttonText: 'Book Now',
    color1: const Color(0xFF6B5CE7),
    color2: const Color(0xFF9F7AEA),
    icon: Icons.health_and_safety_rounded,
  ),
  PromoModel(
    title: '24/7 Emergency\nService',
    description: 'We are always here for you',
    buttonText: 'Call Now',
    color1: const Color(0xFFFF6B6B),
    color2: const Color(0xFFEE5A6F),
    icon: Icons.emergency_rounded,
  ),
];

final List<DoctorModel> _topDoctors = [
  DoctorModel(
    id: '1',
    name: 'Dr. Marcus Horiz',
    specialty: 'Cardiologist',
    imageUrl: '',
    rating: 4.9,
    distance: '800m',
  ),
  DoctorModel(
    id: '2',
    name: 'Dr. Maria Elena',
    specialty: 'Pediatrician',
    imageUrl: '',
    rating: 4.8,
    distance: '1.5km',
  ),
  DoctorModel(
    id: '3',
    name: 'Dr. Stevi Jessi',
    specialty: 'Dentist',
    imageUrl: '',
    rating: 4.8,
    distance: '2km',
  ),
  DoctorModel(
    id: '4',
    name: 'Dr. John Smith',
    specialty: 'Orthopedic',
    imageUrl: '',
    rating: 4.7,
    distance: '2.5km',
  ),
];

final List<ArticleModel> _healthArticles = [
  ArticleModel(
    id: '1',
    title: 'The 25 Healthiest Fruits You Can Eat, According to a Nutritionist',
    imageUrl: '',
    date: 'Jun 10, 2024',
    category: 'Nutrition',
  ),
  ArticleModel(
    id: '2',
    title: '10 Simple Ways to Improve Your Mental Health Today',
    imageUrl: '',
    date: 'Jun 8, 2024',
    category: 'Mental Health',
  ),
  ArticleModel(
    id: '3',
    title: 'How to Build a Strong Immune System Naturally',
    imageUrl: '',
    date: 'Jun 5, 2024',
    category: 'Wellness',
  ),
];
