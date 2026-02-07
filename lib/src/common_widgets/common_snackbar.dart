import 'package:flutter/material.dart';

class CommonSnackbar {
  static void showAnimatedSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required int durationSeconds,
    IconData icon = Icons.info_outline,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _AnimatedSnackbarWidget(
          message: message,
          backgroundColor: backgroundColor,
          textColor: textColor,
          durationSeconds: durationSeconds,
          icon: icon,
          onDismiss: () => overlayEntry.remove(),
        );
      },
    );

    overlay.insert(overlayEntry);
  }
}

class _AnimatedSnackbarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final int durationSeconds;
  final IconData icon;
  final VoidCallback onDismiss;

  const _AnimatedSnackbarWidget({
    required this.message,
    required this.backgroundColor,
    required this.textColor,
    required this.durationSeconds,
    required this.icon,
    required this.onDismiss,
  });

  @override
  State<_AnimatedSnackbarWidget> createState() =>
      _AnimatedSnackbarWidgetState();
}

class _AnimatedSnackbarWidgetState extends State<_AnimatedSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(Duration(seconds: widget.durationSeconds), () async {
      await _controller.reverse();
      widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 26,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(widget.icon, color: widget.textColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: widget.textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
