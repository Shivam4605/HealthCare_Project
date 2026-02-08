import 'package:flutter/material.dart';

class SmoothNavigation {
  static Future<T?> fadeIn<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static Future<T?> slideFromRight<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 350),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Future<T?> slideFromBottom<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  static Future<T?> scale<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOutCubic;

          var scaleTween = Tween(
            begin: 0.8,
            end: 1.0,
          ).chain(CurveTween(curve: curve));

          var fadeTween = Tween(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: ScaleTransition(
              scale: animation.drive(scaleTween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  static Future<T?> fadeSlide<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 500),
    Offset beginOffset = const Offset(0.0, 0.1),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeOutCubic;

          var slideTween = Tween(
            begin: beginOffset,
            end: Offset.zero,
          ).chain(CurveTween(curve: curve));

          var fadeTween = Tween(
            begin: 0.0,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeIn));

          return FadeTransition(
            opacity: animation.drive(fadeTween),
            child: SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            ),
          );
        },
      ),
    );
  }

  static Future<T?> replace<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.pushReplacement<T, void>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  static Future<T?> pushAndRemoveAll<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
  }) {
    return Navigator.pushAndRemoveUntil<T>(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: duration,
        reverseTransitionDuration: duration,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      (route) => false,
    );
  }

  static Future<void> smoothPop(BuildContext context, {dynamic result}) async {
    Navigator.pop(context, result);
  }
}

class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration transitionDuration;
  final SmoothTransitionType transitionType;

  SmoothPageRoute({
    required this.page,
    this.transitionDuration = const Duration(milliseconds: 400),
    this.transitionType = SmoothTransitionType.fadeSlide,
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: transitionDuration,
         reverseTransitionDuration: transitionDuration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return _buildTransition(animation, child, transitionType);
         },
       );

  static Widget _buildTransition(
    Animation<double> animation,
    Widget child,
    SmoothTransitionType type,
  ) {
    switch (type) {
      case SmoothTransitionType.fade:
        return FadeTransition(opacity: animation, child: child);

      case SmoothTransitionType.slideRight:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
          child: child,
        );

      case SmoothTransitionType.slideBottom:
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        );

      case SmoothTransitionType.scale:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
            ),
            child: child,
          ),
        );

      case SmoothTransitionType.fadeSlide:
      default:
        return FadeTransition(
          opacity: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn)),
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          ),
        );
    }
  }
}

enum SmoothTransitionType { fade, slideRight, slideBottom, scale, fadeSlide }
