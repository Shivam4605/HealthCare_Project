import 'package:flutter/material.dart';

class FloatingBubbleNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBubbleNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBubbleItem(0, Icons.home_rounded, 'Home'),
          _buildBubbleItem(1, Icons.local_hospital_rounded, 'Hospitals'),
          _buildBubbleItem(2, Icons.psychology_rounded, 'ChatBot'),
          _buildBubbleItem(3, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildBubbleItem(int index, IconData icon, String title) {
    final bool isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: isSelected ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 400),
        curve: Curves.elasticOut,
        builder: (BuildContext context, double value, Widget? child) {
          final clampedValue = value.clamp(0.0, 1.0);

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF0EA5E9), Color(0xFF0A66C2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(25),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0EA5E9).withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1.0 + (clampedValue * 0.2),
                  child: Icon(
                    icon,
                    size: 24,
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  ),
                ),
                SizedBox(height: isSelected ? 6 : 0),
                if (isSelected)
                  Opacity(
                    opacity: clampedValue,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
