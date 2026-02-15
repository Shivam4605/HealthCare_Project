import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';
import 'package:healthcare/src/controller/Providers/user_provider/user_role_info_provider.dart';
import 'package:healthcare/src/util/app_color.dart';
import 'package:healthcare/src/view/common_screens/auth_select_screen.dart';
import 'package:provider/provider.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() =>
      _AdvancedRoleSelectionScreenState();
}

class _AdvancedRoleSelectionScreenState extends State<RoleSelectionScreen>
    with TickerProviderStateMixin {
  int? _selectedRoleIndex;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late List<AnimationController> _cardControllers;

  final List<UserRole> _roles = [
    UserRole(
      title: 'Patient',
      description: 'Book appointments and consult with doctors',
      iconPath: 'assets/app_images/patient_icon.svg',
      fallbackIcon: Icons.person_outline,
      color: AppColors.midblue,
      gradient: const LinearGradient(
        colors: [AppColors.lightblue, AppColors.midblue],
      ),
    ),
    UserRole(
      title: 'Doctor',
      description: 'Manage patients and provide consultations',
      iconPath: 'assets/app_images/doctor_icon.svg',
      fallbackIcon: Icons.medical_services_outlined,
      color: AppColors.midblue,
      gradient: const LinearGradient(
        colors: [AppColors.lightblue, AppColors.midblue],
      ),
    ),
    UserRole(
      title: 'Medical Staff',
      description: 'Assist doctors and manage healthcare services',
      iconPath: 'assets/app_images/staff_icon.svg',
      fallbackIcon: Icons.local_hospital_outlined,
      color: AppColors.midblue,
      gradient: const LinearGradient(
        colors: [AppColors.lightblue, AppColors.midblue],
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..forward();

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _cardControllers = List.generate(
      _roles.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this,
      )..forward(from: 0.0),
    );

    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _cardControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onRoleSelected(int index) {
    setState(() {
      _selectedRoleIndex = index;
    });
  }

  void _onContinue() {
    if (_selectedRoleIndex == null) {
      _showErrorSnackBar();
      return;
    }

    final selectedRole = _roles[_selectedRoleIndex!];

    final userInfoProvider = Provider.of<UserInfoProvider>(
      context,
      listen: false,
    );
    userInfoProvider.setSelectedRole(selectedRole.title);

    _navigateToNextScreen(selectedRole);
  }

  void _showErrorSnackBar() {
    CommonSnackbar.showAnimatedSnackBar(
      context: context,
      message: "Please select a role to continue",
      backgroundColor: Colors.redAccent,
      durationSeconds: 2,
      textColor: Colors.white,
      icon: Icons.info_outline,
    );
  }

  void _navigateToNextScreen(UserRole role) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => AuthSelectScreen(),
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
    debugPrint('Selected role: ${role.title}');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = ResponsiveHelper(size);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeController,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.horizontalPadding(24),
            ),
            child: Column(
              children: [
                SizedBox(height: responsive.verticalPadding(10)),

                _buildBranding(responsive),

                SizedBox(height: responsive.verticalPadding(40)),

                _buildHeader(responsive),

                SizedBox(height: responsive.verticalPadding(32)),

                Expanded(child: _buildRolesList(responsive)),

                _buildContinueButton(responsive),

                SizedBox(height: responsive.verticalPadding(20)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(ResponsiveHelper responsive) {
    return Column(
      children: [
        Container(
          width: responsive.logoSize(),
          height: responsive.logoSize(),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.lightblue, AppColors.midblue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.lightblue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.medical_services_rounded,
            size: responsive.logoIconSize(),
            color: Colors.white,
          ),
        ),
        SizedBox(height: responsive.verticalPadding(12)),
        Text(
          'Medics+',
          style: TextStyle(
            fontSize: responsive.fontSize(28),
            fontWeight: FontWeight.bold,
            color: AppColors.midblue,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(ResponsiveHelper responsive) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
            CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
          ),
      child: Column(
        children: [
          Text(
            'Select Your Role',
            style: TextStyle(
              fontSize: responsive.fontSize(26),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E3E5C),
            ),
          ),
          SizedBox(height: responsive.verticalPadding(12)),
          Text(
            'Choose how you want to use Medics+\nand enjoy personalized features',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: responsive.fontSize(15),
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesList(ResponsiveHelper responsive) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: _roles.length,
      padding: EdgeInsets.only(bottom: responsive.verticalPadding(8)),
      itemBuilder: (context, index) {
        return FadeTransition(
          opacity: _cardControllers[index],
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _cardControllers[index],
                    curve: Curves.easeOut,
                  ),
                ),
            child: _buildRoleCard(_roles[index], index, responsive),
          ),
        );
      },
    );
  }

  Widget _buildRoleCard(UserRole role, int index, ResponsiveHelper responsive) {
    final isSelected = _selectedRoleIndex == index;

    return GestureDetector(
      onTap: () => _onRoleSelected(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(bottom: responsive.verticalPadding(16)),
        padding: EdgeInsets.all(responsive.horizontalPadding(18)),
        decoration: BoxDecoration(
          color: isSelected ? role.color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? role.color : Colors.grey[300]!,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? role.color.withOpacity(0.25)
                  : Colors.grey.withOpacity(0.08),
              blurRadius: isSelected ? 15 : 10,
              offset: Offset(0, isSelected ? 6 : 4),
              spreadRadius: isSelected ? 1 : 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildRoleIcon(role, isSelected, responsive),

            SizedBox(width: responsive.horizontalPadding(16)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.title,
                    style: TextStyle(
                      fontSize: responsive.fontSize(19),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2E3E5C),
                    ),
                  ),
                  SizedBox(height: responsive.verticalPadding(6)),
                  Text(
                    role.description,
                    style: TextStyle(
                      fontSize: responsive.fontSize(13),
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: responsive.horizontalPadding(8)),

            _buildSelectionIndicator(role, isSelected),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleIcon(
    UserRole role,
    bool isSelected,
    ResponsiveHelper responsive,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: responsive.roleIconSize(),
      height: responsive.roleIconSize(),
      decoration: BoxDecoration(
        gradient: isSelected ? role.gradient : null,
        color: isSelected ? null : role.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: role.color.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: role.iconPath != null
          ? _buildSvgIcon(role, isSelected, responsive)
          : _buildFallbackIcon(role, isSelected, responsive),
    );
  }

  Widget _buildSvgIcon(
    UserRole role,
    bool isSelected,
    ResponsiveHelper responsive,
  ) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SvgPicture.asset(
        role.iconPath!,
        width: responsive.roleIconInnerSize(),
        height: responsive.roleIconInnerSize(),
        colorFilter: ColorFilter.mode(
          isSelected ? Colors.white : role.color,
          BlendMode.srcIn,
        ),
        placeholderBuilder: (context) => Icon(
          role.fallbackIcon,
          size: responsive.roleIconInnerSize(),
          color: isSelected ? Colors.white : role.color,
        ),
      ),
    );
  }

  Widget _buildFallbackIcon(
    UserRole role,
    bool isSelected,
    ResponsiveHelper responsive,
  ) {
    return Icon(
      role.fallbackIcon,
      size: responsive.roleIconInnerSize(),
      color: isSelected ? Colors.white : role.color,
    );
  }

  Widget _buildSelectionIndicator(UserRole role, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedOpacity(
        opacity: isSelected ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            gradient: role.gradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: role.color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    final isEnabled = _selectedRoleIndex != null;
    final selectedColor = isEnabled && _selectedRoleIndex != null
        ? _roles[_selectedRoleIndex!].color
        : const Color(0xFF13BDAC);

    return AnimatedOpacity(
      opacity: isEnabled ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: double.infinity,
        height: responsive.buttonHeight(),
        decoration: BoxDecoration(
          gradient: isEnabled
              ? LinearGradient(
                  colors: [selectedColor, selectedColor.withOpacity(0.8)],
                )
              : null,
          color: isEnabled ? null : Colors.grey[400],
          borderRadius: BorderRadius.circular(14),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: selectedColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          onPressed: _onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'Continue',
            style: TextStyle(
              fontSize: responsive.fontSize(17),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
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

  double logoSize() {
    if (isSmallScreen) return 70;
    if (isMediumScreen) return 80;
    return 90;
  }

  double logoIconSize() {
    if (isSmallScreen) return 36;
    if (isMediumScreen) return 42;
    return 48;
  }

  double roleIconSize() {
    if (isSmallScreen) return 60;
    if (isMediumScreen) return 66;
    return 70;
  }

  double roleIconInnerSize() {
    if (isSmallScreen) return 30;
    if (isMediumScreen) return 33;
    return 36;
  }

  double buttonHeight() {
    if (isSmallScreen) return 52;
    if (isMediumScreen) return 56;
    return 58;
  }
}

class UserRole {
  final String title;
  final String description;
  final String? iconPath;
  final IconData fallbackIcon;
  final Color color;
  final Gradient gradient;

  UserRole({
    required this.title,
    required this.description,
    this.iconPath,
    required this.fallbackIcon,
    required this.color,
    required this.gradient,
  });
}
