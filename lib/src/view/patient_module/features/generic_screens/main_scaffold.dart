import 'package:flutter/material.dart';
import 'package:healthcare/src/view/patient_module/features/generic_screens/bottom_nav_bar.dart';
import 'package:healthcare/src/view/patient_module/features/health_chat_bot.dart';
import 'package:healthcare/src/view/patient_module/features/hospital_screen.dart';
import 'package:healthcare/src/view/patient_module/features/patient_home_screen.dart';
import 'package:healthcare/src/view/patient_module/features/drawar_section_screen/patient_profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentNavIndex = 0;
  final PageController _pageController = PageController();

  late final List<Widget> _pages;

  final List<int> _navToPageIndex = const [0, 1, 2, 3];

  @override
  void initState() {
    super.initState();
    _pages = [
      const PatientHomeScreen(),
      const HospitalsScreen(),
      const HealthChatbotScreen(),
      PatientProfileScreen(isArrowBack: false),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int navIndex) {
    if (_currentNavIndex == navIndex) return;

    final pageIndex = _navToPageIndex[navIndex];
    setState(() {
      _currentNavIndex = navIndex;
    });
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: (pageIndex) {
          final newNavIndex = _navToPageIndex.indexOf(pageIndex);
          if (newNavIndex != -1 && newNavIndex != _currentNavIndex) {
            setState(() => _currentNavIndex = newNavIndex);
          }
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: RepaintBoundary(
        child: FloatingBubbleNavBar(
          currentIndex: _currentNavIndex,
          onTap: _onNavTap,
        ),
      ),
    );
  }
}
