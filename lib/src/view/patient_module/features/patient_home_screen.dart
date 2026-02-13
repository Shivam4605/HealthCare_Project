import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:healthcare/src/controller/auth_provider/logout_provider.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:healthcare/src/view/patient_module/features/patient_notification_screen.dart';
import 'package:healthcare/src/view/patient_module/features/patient_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _headerAnimationController;
  late AnimationController _fabAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _headerScaleAnimation;

  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;
  bool _isLoading = false;
  bool _showLoading = false;

  final String _userName = 'John Doe';
  final String _userEmail = 'john.doe@email.com';
  final int _favoriteCount = 3;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAutoPlay();
    _showLoadingIndicator();
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
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_carouselController.hasClients && mounted) {
        int nextPage = (_currentCarouselIndex + 1) % _promos.length;
        _carouselController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
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

  @override
  Widget build(BuildContext context) {
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
                      .findAncestorStateOfType<_AdvancedDrawerWrapperState>();
                  return GestureDetector(
                    onTap: wrapperState?._handleMenuButtonPressed,
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
                onTap: () {
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
                    children: [
                      const Icon(
                        Icons.notifications_rounded,
                        color: Color(0xFF2E3E5C),
                        size: 24,
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
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
                curve: Curves.easeOutCubic, // Changed from elasticOut
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
          SizedBox(
            height: 180,
            child: PageView.builder(
              controller: _carouselController,
              onPageChanged: (index) {
                setState(() => _currentCarouselIndex = index);
              },
              itemCount: _promos.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: _handleTabSelected,
                    child: _buildPromoCard(_promos[index]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          _buildCarouselIndicators(_promos.length),
        ],
      ),
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
      curve: Curves.easeOutCubic, // Changed from elasticOut
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

// Model Classes
class CategoryItem {
  final IconData icon;
  final String label;
  final Color color;
  final Gradient gradient;

  CategoryItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.gradient,
  });
}

class PromoModel {
  final String title;
  final String description;
  final String buttonText;
  final Color color1;
  final Color color2;
  final IconData icon;

  PromoModel({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.color1,
    required this.color2,
    required this.icon,
  });
}

class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final String distance;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.distance,
  });
}

class ArticleModel {
  final String id;
  final String title;
  final String imageUrl;
  final String date;
  final String category;

  ArticleModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.category,
  });
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

class DrawerTheme {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color darkText = Color(0xFF1E293B);
  static const Color lightText = Color(0xFF64748B);

  static const double drawerBorderRadius = 20;
  static const Duration animationDuration = Duration(milliseconds: 300);

  static BoxDecoration get headerGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryBlue, Color(0xFF2F5ADD)],
    ),
  );

  static BoxDecoration get itemBackground => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration get iconBackground => BoxDecoration(
    color: primaryBlue.withOpacity(0.1),
    borderRadius: BorderRadius.circular(10),
  );
}

class AdvancedDrawerWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback onHomeTap;
  final Function(String) onItemTap;
  final String userName;
  final String userEmail;
  final String? userAvatarUrl;
  final int favoriteCount;

  const AdvancedDrawerWrapper({
    super.key,
    required this.child,
    required this.onHomeTap,
    required this.onItemTap,
    required this.userName,
    required this.userEmail,
    this.userAvatarUrl,
    this.favoriteCount = 0,
  });

  @override
  State<AdvancedDrawerWrapper> createState() => _AdvancedDrawerWrapperState();
}

class _AdvancedDrawerWrapperState extends State<AdvancedDrawerWrapper> {
  late final AdvancedDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = AdvancedDrawerController();
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void _handleMenuButtonPressed() {
    _drawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: _drawerController,
      backdropColor: DrawerTheme.primaryBlue.withOpacity(0.15),
      animationDuration: DrawerTheme.animationDuration,
      openRatio: 0.75,
      openScale: 0.92,
      rtlOpening: false,
      disabledGestures: false,
      drawer: _buildOptimizedDrawer(),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: widget.child,
      ),
    );
  }

  Widget _buildOptimizedDrawer() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
      decoration: DrawerTheme.headerGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(),
          const SizedBox(height: 16),
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return GestureDetector(
      onTap: () {
        _drawerController.hideDrawer();
        widget.onItemTap('profile');
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipOval(
            child:
                widget.userAvatarUrl != null && widget.userAvatarUrl!.isNotEmpty
                ? Image.network(
                    widget.userAvatarUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildAvatarPlaceholder();
                    },
                  )
                : _buildAvatarPlaceholder(),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: Colors.white,
      child: const Icon(Icons.person, size: 35, color: DrawerTheme.primaryBlue),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.userName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.email_rounded, size: 14, color: Colors.white70),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.userEmail,
                style: const TextStyle(fontSize: 13, color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildSection('MAIN MENU'),
        _buildDrawerItem(
          icon: Icons.home_rounded,
          title: 'Home',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onHomeTap();
          },
        ),
        _buildDrawerItem(
          icon: Icons.person_rounded,
          title: 'My Profile',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('profile');
          },
        ),
        _buildDrawerItem(
          icon: Icons.favorite_rounded,
          title: 'Favorites',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('favorites');
          },
          badge: widget.favoriteCount > 0
              ? widget.favoriteCount.toString()
              : null,
        ),
        _buildDrawerItem(
          icon: Icons.history_rounded,
          title: 'Appointment History',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('history');
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Divider(height: 1),
        ),
        _buildSection('MEDICAL'),
        _buildDrawerItem(
          icon: Icons.medical_services_rounded,
          title: 'My Prescriptions',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('prescriptions');
          },
        ),
        _buildDrawerItem(
          icon: Icons.payment_rounded,
          title: 'Payment Methods',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('payments');
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Divider(height: 1),
        ),
        _buildSection('SUPPORT'),
        _buildDrawerItem(
          icon: Icons.settings_rounded,
          title: 'Settings',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('settings');
          },
        ),
        _buildDrawerItem(
          icon: Icons.help_rounded,
          title: 'Help & Support',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('help');
          },
        ),
        _buildDrawerItem(
          icon: Icons.logout_rounded,
          title: 'Logout',
          onTap: () {
            _drawerController.hideDrawer();
            widget.onItemTap('logout');
          },
          color: Colors.red,
        ),
        _buildVersionInfo(),
        SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[500],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? badge,
    Color? color,
  }) {
    final itemColor = color ?? DrawerTheme.primaryBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _buildIcon(icon, itemColor),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: itemColor == Colors.red
                        ? Colors.red
                        : DrawerTheme.darkText,
                  ),
                ),
              ),
              if (badge != null) _buildBadge(badge),
              if (badge == null) _buildArrow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  Widget _buildBadge(String badge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: DrawerTheme.primaryBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        badge,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildArrow() {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: 14,
      color: Colors.grey[400],
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Build With Flutter',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
            ],
          ),
          Icon(
            Icons.favorite_rounded,
            size: 22,
            color: DrawerTheme.primaryBlue.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
