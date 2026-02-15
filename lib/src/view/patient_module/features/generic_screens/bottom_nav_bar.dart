import 'package:flutter/material.dart';

class FloatingBubbleNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FloatingBubbleNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<FloatingBubbleNavBar> createState() => _FloatingBubbleNavBarState();
}

class _FloatingBubbleNavBarState extends State<FloatingBubbleNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _itemAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: widget.currentIndex == index ? 1.0 : 0.0,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOutCubic,
        ),
      );
    });

    if (widget.currentIndex >= 0) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void didUpdateWidget(FloatingBubbleNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      for (int i = 0; i < _itemAnimations.length; i++) {
        _itemAnimations[i] =
            Tween<double>(
              begin: _itemAnimations[i].value,
              end: widget.currentIndex == i ? 1.0 : 0.0,
            ).animate(
              CurvedAnimation(
                parent: _animationController,
                curve: Curves.easeOutCubic,
              ),
            );
      }
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4D1E293B),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_rounded, 'Home'),
          _buildNavItem(1, Icons.local_hospital_rounded, 'Hospitals'),
          _buildNavItem(2, Icons.psychology_rounded, 'ChatBot'),
          _buildNavItem(3, Icons.person_rounded, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = widget.currentIndex == index;
    final animation = _itemAnimations[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final value = animation.value;

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: value > 0 ? 8 : 6,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF0A66C2)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 22,
                    color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                  ),
                  if (isSelected && value > 0.5)
                    Opacity(
                      opacity: value,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
