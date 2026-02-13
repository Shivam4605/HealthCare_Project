import 'package:flutter/material.dart';
import 'package:healthcare/src/view/patient_module/bottom_nav_bar.dart';
import 'package:healthcare/src/view/patient_module/features/health_chat_bot.dart';
import 'package:healthcare/src/view/patient_module/features/hospital_screen.dart';
import 'package:healthcare/src/view/patient_module/features/patient_home_screen.dart';
import 'package:healthcare/src/view/patient_module/features/patient_profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentNavIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    PatientHomeScreen(),
    HospitalsScreen(),
    HealthChatbotScreen(),
    PatientProfileScreen(isArrowBack: false),
  ];

  final List<int> _navToPageIndex = const [0, 1, 2, 3];

  void _onNavTap(int navIndex) {
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
          int newNavIndex = _navToPageIndex.indexOf(pageIndex);
          if (newNavIndex != -1) {
            setState(() => _currentNavIndex = newNavIndex);
          }
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: FloatingBubbleNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
