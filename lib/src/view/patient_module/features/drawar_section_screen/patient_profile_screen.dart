import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/src/common_widgets/circular_progress_indicator.dart';
import 'package:healthcare/src/common_widgets/common_snackbar.dart';
import 'package:healthcare/src/controller/Providers/auth_provider/logout_provider.dart';
import 'package:healthcare/src/controller/Providers/notification_provider/notification_service_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class PatientProfileScreen extends StatefulWidget {
  bool isArrowBack = false;
  PatientProfileScreen({super.key, required this.isArrowBack});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyNameController =
      TextEditingController();
  final TextEditingController _emergencyPhoneController =
      TextEditingController();
  final TextEditingController _insuranceController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();

  bool _isEditMode = false;
  bool _isLoading = false;
  bool _showLoading = true;
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _darkModeEnabled = false;
  bool _locationEnabled = true;
  String _selectedGender = 'Female';
  String _selectedBloodGroup = 'O+';

  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingScaleAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroupOptions = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadSampleData();
    _startLoadingTimer();
  }

  void _initializeAnimations() {
    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _loadingScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _loadingAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _loadingAnimationController.forward();
    _fadeController.forward();
    _slideController.forward();
  }

  void _startLoadingTimer() {
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _showLoading = false;
        });
      }
    });
  }

  void _loadSampleData() {
    _nameController.text = 'Dr. Sarah Johnson';
    _emailController.text = 'sarah.johnson@email.com';
    _phoneController.text = '+1 (555) 123-4567';
    _dobController.text = '15/03/1990';
    _addressController.text =
        '123 Medical Center Blvd, Suite 100\nHealthcare City, HC 12345';
    _emergencyNameController.text = 'John Johnson';
    _emergencyPhoneController.text = '+1 (555) 987-6543';
    _insuranceController.text = 'HealthCare Plus Premium';
    _allergiesController.text = 'Penicillin, Peanuts';
    _medicationsController.text =
        'Metformin 500mg (2x daily)\nLisinopril 10mg (1x daily)';
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _insuranceController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      _showSuccessMessage();
      _toggleEditMode();
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Profile updated successfully!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF13BDAC),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  Future<void> _showLogoutDialog() async {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 24,
          insetAnimationDuration: const Duration(milliseconds: 300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
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
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Container(
                              width: 100 + (value * 20),
                              height: 100 + (value * 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(
                                  0.1 * (1 - value * 0.3),
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
                    child: Wrap(
                      children: [
                        Text(
                          'Are you sure you want to logout from your account?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
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
                        Expanded(
                          child: const Text(
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
                          onPressed: () => Navigator.pop(context),
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
                                Navigator.pop(context);
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

  Future<void> _selectDate() async {
    if (!_isEditMode) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990, 3, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF13BDAC),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: _showLoading
          ? _buildLoadingScreen()
          : _buildMainContent(notificationProvider),
    );
  }

  Widget _buildMainContent(NotificationProvider notification) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(),
        SliverPadding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      _buildProfileHeader(),
                      const SizedBox(height: 20),
                      _buildPersonalInfoSection(),
                      const SizedBox(height: 20),
                      _buildHealthMetricsSection(),
                      const SizedBox(height: 20),
                      _buildEmergencyContactSection(),
                      const SizedBox(height: 20),
                      _buildMedicalInfoSection(),
                      const SizedBox(height: 20),
                      _buildSettingsSection(notification),
                      const SizedBox(height: 20),
                      _buildActionButtons(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 60,
      floating: true,
      snap: true,
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: widget.isArrowBack
          ? Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF13BDAC).withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: Color(0xFF2E3E5C)),
                onPressed: () => Navigator.pop(context),
              ),
            )
          : null,
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _loadingScaleAnimation,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                gradient: const RadialGradient(
                  colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF13BDAC).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.health_and_safety,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: const Column(
              children: [
                Text(
                  'Loading Profile',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Please wait while we fetch your data',
                  style: TextStyle(fontSize: 16, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 50),

          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: const Color(0xFF13BDAC).withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF13BDAC),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Row(mainAxisAlignment: MainAxisAlignment.center),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF13BDAC).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.pattern_rounded,
              size: 150,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          'https://ui-avatars.com/api/?name=Sarah+Johnson&size=200&background=13BDAC&color=fff',
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF13BDAC),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Color(0xFF13BDAC),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Text(
                  _nameController.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Patient',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.email_rounded,
                      size: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _emailController.text,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('12', 'Appointments', Icons.calendar_month),
                    _buildStatCard('5', 'Doctors', Icons.people),
                    _buildStatCard('28', 'Records', Icons.folder),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Personal Information',
      icon: Icons.person_outline_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
      ),
      child: Column(
        children: [
          _buildAnimatedField(
            index: 0,
            child: _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_outline,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 1,
            child: _buildTextField(
              controller: _emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 2,
            child: _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 3,
            child: _buildTextField(
              controller: _dobController,
              label: 'Date of Birth',
              icon: Icons.cake_outlined,
              readOnly: true,
              onTap: _selectDate,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 4,
            child: Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Gender',
                    icon: Icons.wc_outlined,
                    value: _selectedGender,
                    items: _genderOptions,
                    onChanged: (value) {
                      setState(() => _selectedGender = value!);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Blood Group',
                    icon: Icons.bloodtype_outlined,
                    value: _selectedBloodGroup,
                    items: _bloodGroupOptions,
                    onChanged: (value) {
                      setState(() => _selectedBloodGroup = value!);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 5,
            child: _buildTextField(
              controller: _addressController,
              label: 'Address',
              icon: Icons.location_on_outlined,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetricsSection() {
    return _buildSection(
      title: 'Health Metrics',
      icon: Icons.favorite_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: [
          _buildHealthCard(
            icon: Icons.monitor_weight_outlined,
            label: 'Weight',
            value: '70 kg',
            color: const Color(0xFF6B5CE7),
            gradient: const LinearGradient(
              colors: [Color(0xFF6B5CE7), Color(0xFF8B7BFF)],
            ),
          ),
          _buildHealthCard(
            icon: Icons.height_outlined,
            label: 'Height',
            value: '175 cm',
            color: const Color(0xFF13BDAC),
            gradient: const LinearGradient(
              colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
            ),
          ),
          _buildHealthCard(
            icon: Icons.favorite_outline,
            label: 'Heart Rate',
            value: '72 bpm',
            color: const Color(0xFFFF6B6B),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFEE5A6F)],
            ),
          ),
          _buildHealthCard(
            icon: Icons.thermostat_outlined,
            label: 'Temperature',
            value: '36.6°C',
            color: const Color(0xFFFFA07A),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFA07A), Color(0xFFFF8E8E)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactSection() {
    return _buildSection(
      title: 'Emergency Contact',
      icon: Icons.emergency_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFFFFA07A), Color(0xFFFF8E8E)],
      ),
      child: Column(
        children: [
          _buildAnimatedField(
            index: 0,
            child: _buildTextField(
              controller: _emergencyNameController,
              label: 'Contact Name',
              icon: Icons.person_outline,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 1,
            child: _buildTextField(
              controller: _emergencyPhoneController,
              label: 'Contact Phone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalInfoSection() {
    return _buildSection(
      title: 'Medical Information',
      icon: Icons.medical_services_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF6B5CE7), Color(0xFF8B7BFF)],
      ),
      child: Column(
        children: [
          _buildAnimatedField(
            index: 0,
            child: _buildTextField(
              controller: _insuranceController,
              label: 'Insurance Provider',
              icon: Icons.shield_outlined,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 1,
            child: _buildTextField(
              controller: _allergiesController,
              label: 'Allergies',
              icon: Icons.warning_amber_outlined,
              maxLines: 2,
            ),
          ),
          const SizedBox(height: 16),
          _buildAnimatedField(
            index: 2,
            child: _buildTextField(
              controller: _medicationsController,
              label: 'Current Medications',
              icon: Icons.medication_outlined,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showNotificationDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 24,
          insetAnimationDuration: const Duration(milliseconds: 300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(scale: scale, child: child);
            },
            child: Container(
              width: 340,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Color(0xFFF8F9FF)],
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF13BDAC), Color(0xFF0EA5E9)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Enable Notifications?",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E3E5C),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Allow reminders, updates and important alerts.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child:
                              Provider.of<NotificationProvider>(
                                context,
                                listen: false,
                              ).enabled
                              ? const Text("Disable")
                              : const Text("Allow"),
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

  Widget _buildSettingsSection(NotificationProvider notification) {
    return _buildSection(
      title: 'Settings',
      icon: Icons.settings_rounded,
      gradient: const LinearGradient(
        colors: [Color(0xFF64748B), Color(0xFF475569)],
      ),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive appointment reminders',
            value: notification.enabled,
            onChanged: (value) async {
              final s = await FirebaseMessaging.instance
                  .getNotificationSettings();
              log("${s.authorizationStatus}");
              final confirm = await _showNotificationDialog();
              if (confirm != true) return;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(
                  child: CustomCircularProgressIndicator()
                      .circularProgressIndicator(),
                ),
              );

              try {
                final messaging = FirebaseMessaging.instance;

                if (value) {
                  final settings = await messaging.getNotificationSettings();

                  if (settings.authorizationStatus ==
                      AuthorizationStatus.notDetermined) {
                    final result = await messaging.requestPermission();

                    if (result.authorizationStatus !=
                        AuthorizationStatus.authorized) {
                      Navigator.pop(context);
                      return;
                    }
                  }

                  if (settings.authorizationStatus ==
                      AuthorizationStatus.denied) {
                    await openAppSettings();
                    Navigator.pop(context);
                    return;
                  }

                  await notification.enableNotifications();

                  CommonSnackbar.showAnimatedSnackBar(
                    context: context,
                    message: 'Notification Enabled Successfully',
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    durationSeconds: 2,
                    icon: Icons.check_circle_outline,
                  );
                } else {
                  await notification.disableNotifications();

                  CommonSnackbar.showAnimatedSnackBar(
                    context: context,
                    message: 'Notification Disabled Successfully',
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    durationSeconds: 2,
                    icon: Icons.check_circle_outline,
                  );
                }
              } catch (e) {
                log("$e");
              } finally {
                Navigator.of(context, rootNavigator: true).pop();
              }
            },
          ),

          const SizedBox(height: 12),

          _buildSwitchTile(
            icon: Icons.location_on_outlined,
            title: 'Location Services',
            subtitle: 'Find nearby hospitals',
            value: _locationEnabled,
            onChanged: (value) => setState(() => _locationEnabled = value),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required LinearGradient gradient,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: gradient.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: gradient.colors.first.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3E5C),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isEditMode
            ? [
                BoxShadow(
                  color: const Color(0xFF13BDAC).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: controller,
        enabled: _isEditMode,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Color(0xFF2E3E5C), fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: _isEditMode
                ? const Color(0xFF13BDAC)
                : const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: _isEditMode
                ? const Color(0xFF13BDAC)
                : const Color(0xFF9E9E9E),
            size: 22,
          ),
          filled: true,
          fillColor: _isEditMode
              ? const Color(0xFFF0F9F8)
              : const Color(0xFFF8F8F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF13BDAC).withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF13BDAC), width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _isEditMode
            ? [
                BoxShadow(
                  color: const Color(0xFF13BDAC).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: _isEditMode
                ? const Color(0xFF13BDAC)
                : const Color(0xFF9E9E9E),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(
            icon,
            color: _isEditMode
                ? const Color(0xFF13BDAC)
                : const Color(0xFF9E9E9E),
            size: 22,
          ),
          filled: true,
          fillColor: _isEditMode
              ? const Color(0xFFF0F9F8)
              : const Color(0xFFF8F8F8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: const Color(0xFF13BDAC).withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF13BDAC), width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item));
        }).toList(),
        onChanged: _isEditMode ? onChanged : null,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _isEditMode
              ? const Color(0xFF13BDAC)
              : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }

  Widget _buildHealthCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required LinearGradient gradient,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: value ? const Color(0xFFF0F9F8) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? const Color(0xFF13BDAC).withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: value
                ? const Color(0xFF13BDAC).withOpacity(0.1)
                : Colors.transparent,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF13BDAC),
        secondary: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: value
                ? const Color(0xFF13BDAC).withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: value ? const Color(0xFF13BDAC) : Colors.grey[600],
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: value ? const Color(0xFF13BDAC) : const Color(0xFF2E3E5C),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: value
                ? const Color(0xFF13BDAC).withOpacity(0.8)
                : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedField({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildActionButtons() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        );
      },
      child: _isEditMode
          ? Row(
              key: const ValueKey('edit_buttons'),
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _toggleEditMode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF2E3E5C),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: Colors.grey[300]!, width: 1.5),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF13BDAC), Color(0xFF0FA394)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF13BDAC).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : SizedBox(
              key: const ValueKey('logout_button'),
              width: double.infinity,
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
                child: ElevatedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
    );
  }
}
