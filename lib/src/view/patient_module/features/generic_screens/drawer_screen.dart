import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';

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
      colors: [primaryBlue, Color.fromARGB(255, 25, 59, 164)],
    ),
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
  State<AdvancedDrawerWrapper> createState() => AdvancedDrawerWrapperState();
}

class AdvancedDrawerWrapperState extends State<AdvancedDrawerWrapper> {
  late final AdvancedDrawerController drawerController;

  @override
  void initState() {
    super.initState();
    drawerController = AdvancedDrawerController();
  }

  @override
  void dispose() {
    drawerController.dispose();
    super.dispose();
  }

  void handleMenuButtonPressed() {
    drawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      controller: drawerController,
      backdropColor: DrawerTheme.primaryBlue.withOpacity(0.15),
      animationDuration: DrawerTheme.animationDuration,
      openRatio: 0.75,
      openScale: 0.92,
      rtlOpening: false,
      disabledGestures: false,
      drawer: buildOptimizedDrawer(),
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: widget.child,
      ),
    );
  }

  Widget buildOptimizedDrawer() {
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
        drawerController.hideDrawer();
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
            drawerController.hideDrawer();
            widget.onHomeTap();
          },
        ),
        _buildDrawerItem(
          icon: Icons.person_rounded,
          title: 'My Profile',
          onTap: () {
            drawerController.hideDrawer();
            widget.onItemTap('profile');
          },
        ),
        _buildDrawerItem(
          icon: Icons.favorite_rounded,
          title: 'Favorites',
          onTap: () {
            drawerController.hideDrawer();
            widget.onItemTap('favorites');
          },
        ),
        _buildDrawerItem(
          icon: Icons.shopping_cart,
          title: 'Pharmacy Cart',
          onTap: () {
            drawerController.hideDrawer();
            widget.onItemTap('Pharmacy Cart');
          },
        ),
        _buildDrawerItem(
          icon: Icons.history_rounded,
          title: 'Appointment History',
          onTap: () {
            drawerController.hideDrawer();
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
            drawerController.hideDrawer();
            widget.onItemTap('prescriptions');
          },
        ),
        _buildDrawerItem(
          icon: Icons.payment_rounded,
          title: 'Payment Methods',
          onTap: () {
            drawerController.hideDrawer();
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
            drawerController.hideDrawer();
            widget.onItemTap('settings');
          },
        ),
        _buildDrawerItem(
          icon: Icons.help_rounded,
          title: 'Help & Support',
          onTap: () {
            drawerController.hideDrawer();
            widget.onItemTap('help');
          },
        ),
        _buildDrawerItem(
          icon: Icons.logout_rounded,
          title: 'Logout',
          onTap: () {
            drawerController.hideDrawer();
            widget.onItemTap('logout');
          },
          color: Colors.red,
        ),
        _buildVersionInfo(),
        const SizedBox(height: 100),
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
