import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../router/app_router.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _subtitleFadeAnimation;
  late final Animation<double> _shimmerFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Logo fade-in: 0% → 50%
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    // Logo scale: 0.6 → 1.0 over 0% → 60%
    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
      ),
    );

    // Subtitle fade-in: 40% → 80%
    _subtitleFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 0.8, curve: Curves.easeOut),
    );

    // Shimmer fade-in: 60% → 100%
    _shimmerFadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.router.replace(const MainLayoutRoute());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.navyDark,
              AppColors.navyDarkest,
              AppColors.navyDarkest,
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              // Animated logo section
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Decorative accent line above logo
                      Container(
                        width: 40,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.silverDark,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusCircle,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xxl),
                      // FARCHIS text logo
                      Text(
                        'FARCHIS',
                        style: GoogleFonts.outfit(
                          fontSize: 42,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          letterSpacing: 12,
                          height: 1.0,
                        ),
                        semanticsLabel: 'Farchis',
                      ),
                      const SizedBox(height: AppDimensions.sm),
                    ],
                  ),
                ),
              ),
              // Subtitle with its own staggered fade
              FadeTransition(
                opacity: _subtitleFadeAnimation,
                child: Text(
                  'AUTOMOTIVE',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: AppColors.silverDark,
                    letterSpacing: 6,
                    height: 1.0,
                  ),
                  semanticsLabel: 'Automotive',
                ),
              ),
              const Spacer(flex: 3),
              // Shimmer loading indicator
              FadeTransition(
                opacity: _shimmerFadeAnimation,
                child: const _ShimmerLoadingBar(),
              ),
              const SizedBox(height: AppDimensions.huge),
            ],
          ),
        ),
      ),
    );
  }
}

/// A subtle animated shimmer bar as a loading indicator.
class _ShimmerLoadingBar extends StatefulWidget {
  const _ShimmerLoadingBar();

  @override
  State<_ShimmerLoadingBar> createState() => _ShimmerLoadingBarState();
}

class _ShimmerLoadingBarState extends State<_ShimmerLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 2,
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          return CustomPaint(
            painter: _ShimmerPainter(
              progress: _shimmerController.value,
            ),
          );
        },
      ),
    );
  }
}

/// Custom painter that draws a travelling highlight across a thin bar.
class _ShimmerPainter extends CustomPainter {
  final double progress;

  _ShimmerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Background bar
    final bgPaint = Paint()
      ..color = const Color.fromARGB(30, 148, 163, 184) // silverDark at ~12%
      ..style = PaintingStyle.fill;
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(1),
    );
    canvas.drawRRect(bgRect, bgPaint);

    // Shimmer highlight
    const highlightWidth = 40.0;
    final totalTravel = size.width + highlightWidth;
    final center = -highlightWidth + (totalTravel * progress);

    final shader = const LinearGradient(
      colors: [
        Color(0x00FFFFFF),
        Color(0x80FFFFFF),
        Color(0x00FFFFFF),
      ],
    ).createShader(
      Rect.fromCenter(
        center: Offset(center, size.height / 2),
        width: highlightWidth,
        height: size.height,
      ),
    );

    final shimmerPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.fill;

    canvas.drawRRect(bgRect, shimmerPaint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
